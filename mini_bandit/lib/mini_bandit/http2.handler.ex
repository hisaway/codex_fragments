defmodule HTTP2Handler do
  use ThousandIsland.Handler

  @impl ThousandIsland.Handler
  def handle_connection(socket, state) do
    # HTTP/2 設定
    settings = %{
      initial_window_size: 65535,
      max_concurrent_streams: 100,
      enable_push: false
    }

    # HTTP/2 プリアンブル送信
    ThousandIsland.Socket.send(socket, "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n")

    # SETTINGS フレーム送信
    send_settings_frame(socket, settings)

    {:continue, state}
  end

  @impl ThousandIsland.Handler
  def handle_data(data, socket, state) do
    str = File.read!("./hello_world.html")

    # HTTP/2 レスポンスヘッダーフレーム
    headers = [
      {":status", "200"},
      {"content-type", "text/html"},
      {"content-length", "#{byte_size(str)}"}
    ]
    send_headers_frame(socket, headers)

    # データフレーム送信
    send_data_frame(socket, str)

    {:close, state}
  end

  # SETTINGS フレーム作成・送信
  defp send_settings_frame(socket, settings) do
    payload = encode_settings(settings)
    frame = <<byte_size(payload)::24, 0x4::8, 0x0::8, 0x0::32, payload::binary>>
    ThousandIsland.Socket.send(socket, frame)
  end

  # HEADERS フレーム作成・送信
  defp send_headers_frame(socket, headers) do
    payload = encode_headers(headers)
    frame = <<byte_size(payload)::24, 0x1::8, 0x4::8, 0x0::32, payload::binary>>
    ThousandIsland.Socket.send(socket, frame)
  end

  # DATA フレーム作成・送信
  defp send_data_frame(socket, data) do
    frame = <<byte_size(data)::24, 0x0::8, 0x1::8, 0x0::32, data::binary>>
    ThousandIsland.Socket.send(socket, frame)
  end

  # ヘルパー関数
  defp encode_settings(settings), do: ""  # 実際のエンコード処理は省略
  defp encode_headers(headers), do: ""    # 実際のエンコード処理は省略
end
