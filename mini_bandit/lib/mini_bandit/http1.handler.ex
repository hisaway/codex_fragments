defmodule HTTP1Handler do
  use ThousandIsland.Handler

  @impl ThousandIsland.Handler
  def handle_data(_data, socket, state) do
    IO.puts("HTTP1")
    str = File.read!("./hello_world.html")
    ThousandIsland.Socket.send(socket, "HTTP/1.0 200 OK\r\n\r\n#{str}")
    {:close, state}
  end
end
