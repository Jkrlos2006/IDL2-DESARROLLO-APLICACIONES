import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'cart_model.dart';
import 'product.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _paymentMethodController.text = 'Efectivo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
        backgroundColor: const Color.fromARGB(255, 104, 10, 10),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.products.length,
            itemBuilder: (context, index) {
              Product product = cart.products.keys.toList()[index];
              int quantity = cart.products[product]!;
              return ListTile(
                title: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Precio: \S/ ${product.price.toStringAsFixed(2)} - Cantidad: $quantity',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 64, 68, 70),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove_shopping_cart),
                  onPressed: () {
                    cart.removeProduct(product);
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartModel>(
        builder: (context, cart, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \S/ ${cart.totalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text('Ingrese sus datos'),
                              content: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DropdownButtonFormField<String>(
                                        value: _paymentMethodController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _paymentMethodController.text =
                                                value!;
                                          });
                                        },
                                        items: [
                                          'Efectivo',
                                          'Tarjeta de Débito',
                                          'Tarjeta de Crédito'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                            labelText: 'Método de Pago'),
                                      ),
                                      if (_paymentMethodController.text ==
                                              'Tarjeta de Débito' ||
                                          _paymentMethodController.text ==
                                              'Tarjeta de Crédito')
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller: _cardNumberController,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      'Número de Tarjeta'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Por favor, ingrese el número de tarjeta.';
                                                }
                                                return null;
                                              },
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _expiryDateController,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'Fecha de Vencimiento'),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Por favor, ingrese la fecha de vencimiento.';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: _cvvController,
                                                    decoration: InputDecoration(
                                                        labelText: 'CVV'),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Por favor, ingrese el CVV.';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                            labelText: 'Nombres'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese su nombre.';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                            labelText: 'Teléfono'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese su número de teléfono.';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                            labelText: 'Dirección'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese su dirección.';
                                          }
                                          return null;
                                        },
                                      ),
                                      if (_selectedImage != null)
                                        Image.file(_selectedImage!),
                                      ElevatedButton(
                                        onPressed: () async {
                                          File? newImage = await _getImage(
                                              source: ImageSource.camera);
                                          if (newImage != null) {
                                            setState(() {
                                              _selectedImage = newImage;
                                            });
                                          }
                                        },
                                        child: Text('Seleccionar Imagen'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      String cardNumber = _cardNumberController
                                          .text
                                          .replaceAll(RegExp(r'\s'), '');

                                      if (cardNumber.length < 16 ||
                                          cardNumber.length > 16) {
                                        // Mostrar mensaje de error
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'Lo sentimos, ocurrió un error. Vuelva a intentarlo.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Regresar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        // Mostrar mensaje de éxito
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Éxito'),
                                              content: Text(
                                                  'Gracias, su compra ha sido realizada.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cerrar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Text('Pagar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text('Pagar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<File?> _getImage({ImageSource source = ImageSource.gallery}) async {
  final picker = ImagePicker();
  try {
    XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  } catch (e) {
    print('Error al obtener la imagen: $e');
  }
  return null;
}
