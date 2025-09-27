import 'package:flutter/material.dart';

class StoreNotFound extends StatelessWidget {
  const StoreNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja não encontrada'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_outlined,
                  size: 96, color: Colors.grey[600]),
              const SizedBox(height: 16),
              const Text(
                'Desculpe, a loja não foi encontrada para este domínio.',
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
