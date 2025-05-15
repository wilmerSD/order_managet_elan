import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initSocket() {
    socket = IO.io(
      'https://8545-181-176-231-118.ngrok-free.app', // usa la URL de ngrok actual
      IO.OptionBuilder()
          .setTransports(['websocket']) // usa websocket puro
          .disableAutoConnect() // opcional si quieres conectar manualmente
          .build(),
    );

    socket.connect();

    // Eventos de conexión
    socket.onConnect((_) {
      print('🟢 Conectado al WebSocket');
    });

    socket.onDisconnect((_) {
      print('🔴 Desconectado del WebSocket');
    });
    // Escuchar nuevo pedido
    socket.on('nuevo_pedido', (data) {
      // print('📦 Pedido nuevo recibido: $data');
      // Aquí puedes hacer algo con el pedido, como notificar al usuario o actualizar la UI
    });
  }

  void sendIdOrderDelivered(id) {
    socket.emit('order_delivered', id);
  }

  void dispose() {
    socket.disconnect();
  }
}
