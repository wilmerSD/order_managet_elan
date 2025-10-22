import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  final link = 'https://backend-elan.onrender.com';//Prod
  // final link = 'https://7a6331c4c5e7.ngrok-free.app';//DEV
  void initSocket() {
    socket = IO.io(
      link,
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

  void sendIdOrderDelivered(id, status) {
    socket.emit('order_delivered', {'orderId': id, 'status': status});
  }

  void dispose() {
    socket.disconnect();
  }
}
