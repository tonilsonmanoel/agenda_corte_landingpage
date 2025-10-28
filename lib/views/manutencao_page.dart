import 'package:flutter/material.dart';

class ManutencaoPage extends StatelessWidget {
  const ManutencaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site de barbearia em Manutenção'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.miscellaneous_services,
                  size: 96, color: Colors.grey[600]),
              const SizedBox(height: 16),
              const Text(
                'Desculpe, o site de barbearia em manutenção\nTente novamente mais tarde.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
