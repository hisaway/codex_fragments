defmodule MiniBandit do
  def start_link(name \\ :mini, opts \\ [mode: :http1, port: 4003]) do
    # 再起動前に前の名前があれば消す
    old_pid = Process.whereis(name)
    unless is_nil(old_pid), do: Supervisor.stop(old_pid)

    case opts[:mode] do
      :http1 ->
        [
          handler_module: HTTP1Handler,
          port: opts[:port]
        ]

      :http2 ->
        IO.puts("HERE")
        [
          handler_moduler: HTTP2Handler,
          port: opts[:port]
        ]
    end
    |> ThousandIsland.start_link()
    |> case do
      {:ok, pid} ->
        Process.register(pid, name)

        {:ok, pid}

      {:error, _} = error ->
        error
    end
  end
end
