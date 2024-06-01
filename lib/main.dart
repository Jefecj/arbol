import 'dart:math'; // Importa la biblioteca de matemáticas
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter

// Definimos la clase Nodo (Node)
class Node {
  int key; // La clave del nodo
  int _height = 1; // La altura del nodo
  Node? left, right; // Los nodos hijos a la izquierda y derecha

  Node(this.key); // Constructor para crear un nodo con una clave

  int get height => _height; // Getter para obtener la altura del nodo

  set height(int value) =>
      _height = value; // Setter para establecer la altura del nodo
}

// Definimos la clase del Árbol AVL (AVLTree)
class AVLTree {
  Node? root; // La raíz del árbol

  // Método para insertar un nodo en el árbol
  Node insert(Node? node, int key) {
    if (node == null)
      return Node(key); // Si el nodo es nulo, creamos un nuevo nodo

    // Si la clave es menor, insertamos en el subárbol izquierdo
    if (key < node.key) {
      node.left = insert(node.left, key);
    }
    // Si la clave es mayor, insertamos en el subárbol derecho
    else if (key > node.key) {
      node.right = insert(node.right, key);
    }
    // Si la clave ya existe, no hacemos nada
    else {
      return node;
    }

    // Actualizamos la altura del nodo
    node.height = 1 + max(_height(node.left), _height(node.right));

    int balance = _getBalance(node); // Obtenemos el balance del nodo

    // Realizamos rotaciones si el árbol está desbalanceado
    if (balance > 1 && key < node.left!.key) {
      return _rotateRight(node);
    }

    if (balance < -1 && key > node.right!.key) {
      return _rotateLeft(node);
    }

    if (balance > 1 && key > node.left!.key) {
      node.left = _rotateLeft(node.left!);
      return _rotateRight(node);
    }

    if (balance < -1 && key < node.right!.key) {
      node.right = _rotateRight(node.right!);
      return _rotateLeft(node);
    }

    return node; // Devolvemos el nodo
  }

  // Método para eliminar un nodo del árbol
  Node? delete(Node? root, int key) {
    if (root == null) {
      return null; // Si el nodo es nulo, devolvemos nulo
    }

    if (key < root.key) {
      root.left =
          delete(root.left, key); // Buscamos el nodo en el subárbol izquierdo
    } else if (key > root.key) {
      root.right =
          delete(root.right, key); // Buscamos el nodo en el subárbol derecho
    } else {
      if (root.left == null) {
        return root
            .right; // Si no hay subárbol izquierdo, devolvemos el derecho
      } else if (root.right == null) {
        return root.left; // Si no hay subárbol derecho, devolvemos el izquierdo
      }

      Node maxValueNode = maxValue(root
          .left!); // Buscamos el nodo con el valor máximo en el subárbol izquierdo

      root.key = maxValueNode.key; // Reemplazamos la clave del nodo

      root.left = delete(root.left,
          maxValueNode.key); // Eliminamos el nodo con el valor máximo
    }

    // Actualizamos la altura del nodo
    root.height = 1 + max(_height(root.left), _height(root.right));

    int balance = _getBalance(root); // Obtenemos el balance del nodo

    // Realizamos rotaciones si el árbol está desbalanceado
    if (balance > 1 && _getBalance(root.left) >= 0) {
      return _rotateRight(root);
    }

    if (balance > 1 && _getBalance(root.left) < 0) {
      root.left = _rotateLeft(root.left!);
      return _rotateRight(root);
    }

    if (balance < -1 && _getBalance(root.right) <= 0) {
      return _rotateLeft(root);
    }

    if (balance < -1 && _getBalance(root.right) > 0) {
      root.right = _rotateRight(root.right!);
      return _rotateLeft(root);
    }

    return root; // Devolvemos el nodo
  }

  // Métodos para recorrer el árbol en preorden, en orden y postorden
  List<int> preOrderTraversal(Node? node) {
    List<int> result = [];
    if (node != null) {
      result.add(node.key);
      result.addAll(preOrderTraversal(node.left));
      result.addAll(preOrderTraversal(node.right));
    }
    return result;
  }

  List<int> inOrderTraversal(Node? node) {
    List<int> result = [];
    if (node != null) {
      result.addAll(inOrderTraversal(node.left));
      result.add(node.key);
      result.addAll(inOrderTraversal(node.right));
    }
    return result;
  }

  List<int> postOrderTraversal(Node? node) {
    List<int> result = [];
    if (node != null) {
      result.addAll(postOrderTraversal(node.left));
      result.addAll(postOrderTraversal(node.right));
      result.add(node.key);
    }
    return result;
  }

  // Método para obtener la altura de un nodo
  int _height(Node? node) {
    return node?.height ?? 0;
  }

  // Método para obtener el valor máximo entre dos valores
  int max(int a, int b) {
    return a > b ? a : b;
  }

  // Método para obtener el balance de un nodo
  int _getBalance(Node? node) {
    if (node == null) return 0;
    return _height(node.left) - _height(node.right);
  }

  // Método para rotar un nodo a la derecha
  Node _rotateRight(Node y) {
    Node x = y.left!;
    Node? T2 = x.right;

    x.right = y;
    y.left = T2;

    y.height = max(_height(y.left), _height(y.right)) + 1;
    x.height = max(_height(x.left), _height(x.right)) + 1;

    return x;
  }

  // Método para rotar un nodo a la izquierda
  Node _rotateLeft(Node x) {
    Node y = x.right!;
    Node? T2 = y.left;

    y.left = x;
    x.right = T2;

    x.height = max(_height(x.left), _height(x.right)) + 1;
    y.height = max(_height(y.left), _height(y.right)) + 1;

    return y;
  }

  // Método para obtener el nodo con el valor máximo
  Node maxValue(Node node) {
    while (node.right != null) {
      node = node.right!;
    }
    return node;
  }
}

// Función principal que inicia la aplicación
void main() {
  runApp(AVLTreeApp());
}

// Definimos la aplicación Flutter
class AVLTreeApp extends StatefulWidget {
  @override
  _AVLTreeAppState createState() => _AVLTreeAppState();
}

class _AVLTreeAppState extends State<AVLTreeApp> {
  final _avlTree = AVLTree(); // Creamos una instancia del árbol AVL
  final _controller =
      TextEditingController(); // Controlador para el campo de texto de inserción
  final _deleteController =
      TextEditingController(); // Controlador para el campo de texto de eliminación

  List<int> preOrderValues = []; // Lista para los valores en preorden
  List<int> inOrderValues = []; // Lista para los valores en orden
  List<int> postOrderValues = []; // Lista para los valores en postorden

  bool showPreOrder = false; // Mostrar o no la lista en preorden
  bool showInOrder = false; // Mostrar o no la lista en orden
  bool showPostOrder = false; // Mostrar o no la lista en postorden

  String invalidValueMessage = ''; // Mensaje para valores inválidos

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Árbol AVL',
      theme: ThemeData(
        secondaryHeaderColor: Color.fromARGB(255, 43, 201, 8),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Árbol AVL'),
          backgroundColor: Color.fromARGB(255, 3, 255, 70), //Cambiar color franja superior
          actions: [
            IconButton(
              onPressed: _clearTree,
              icon: Icon(Icons.clear),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (invalidValueMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    invalidValueMessage,
                    style: TextStyle(color: Color.fromARGB(255, 244, 54, 54)), //Cambiar color de mensaje Ingrese un valor valido
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildColumn('Pre Orden', preOrderValues, showPreOrder,
                            _togglePreOrderVisibility),
                        _buildColumn('En Orden', inOrderValues, showInOrder,
                            _toggleInOrderVisibility),
                        _buildColumn('Post Orden', postOrderValues,
                            showPostOrder, _togglePostOrderVisibility),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Insertar valor'),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _insertValue(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _insertValue(context),
                    child: Text(
                      'Insertar',
                      style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(6, 214, 37, 1)), //Cambiar color de boton insertar
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _deleteController,
                      decoration: InputDecoration(
                        labelText: 'Eliminar valor',
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _deleteValue(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _deleteValue(context),
                    child: Text(
                      'Eliminar',
                      style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 0, 0, 1)), //Cambiar color boton eliminar
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Container(
                    height: 600, // Ajusta este valor según tus necesidades
                    width: double.infinity,
                    child: CustomPaint(
                      painter: TreePainter(_avlTree.root),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para limpiar el árbol
  void _clearTree() {
    setState(() {
      _avlTree.root = null;
      preOrderValues.clear();
      inOrderValues.clear();
      postOrderValues.clear();
      invalidValueMessage = '';
    });
  }

  // Función para insertar un valor en el árbol
  void _insertValue(BuildContext context) {
    final value = int.tryParse(_controller.text);
    if (value != null && value > 0) {
      _avlTree.root = _avlTree.insert(_avlTree.root, value);
      _controller.clear();
      // Ocultar el teclado al presionar el botón de insertar
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        invalidValueMessage = '';
      });
    } else {
      setState(() {
        invalidValueMessage =
            'Valor inválido. Por favor ingrese un valor entero válido mayor que 0.';
      });
    }
  }

  // Función para eliminar un valor del árbol
  void _deleteValue(BuildContext context) {
    final value = int.tryParse(_deleteController.text);
    if (value != null) {
      // Verificar si el valor está presente en el árbol
      if (!_avlTree.inOrderTraversal(_avlTree.root).contains(value)) {
        // Si el valor no está presente, mostramos un mensaje de error
        setState(() {
          invalidValueMessage = 'El valor $value no existe en el árbol.';
        });
      } else {
        // Si el valor está presente, intentamos eliminarlo del árbol
        final deleted = _avlTree.delete(_avlTree.root, value);
        if (deleted == null) {
          // Si el valor no se encuentra en el árbol, mostramos un mensaje de error
          setState(() {
            invalidValueMessage =
                'El valor $value no se encuentra en el árbol.';
          });
        } else {
          // Si se eliminó correctamente, limpiamos el mensaje de error
          setState(() {
            invalidValueMessage = '';
          });
        }
      }
      _deleteController.clear();
      // Ocultar el teclado al presionar el botón de eliminar
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      // Si el valor ingresado no es válido, mostramos un mensaje de error
      setState(() {
        invalidValueMessage =
            'Valor inválido. Por favor ingrese un valor entero válido.';
      });
    }
  }

  // Función para alternar la visibilidad de la lista en preorden
  void _togglePreOrderVisibility() {
    setState(() {
      showPreOrder = !showPreOrder;
      if (showPreOrder) {
        preOrderValues = _avlTree.preOrderTraversal(_avlTree.root);
      } else {
        preOrderValues.clear();
      }
    });
  }

  // Función para alternar la visibilidad de la lista en orden
  void _toggleInOrderVisibility() {
    setState(() {
      showInOrder = !showInOrder;
      if (showInOrder) {
        inOrderValues = _avlTree.inOrderTraversal(_avlTree.root);
      } else {
        inOrderValues.clear();
      }
    });
  }

  // Función para alternar la visibilidad de la lista en postorden
  void _togglePostOrderVisibility() {
    setState(() {
      showPostOrder = !showPostOrder;
      if (showPostOrder) {
        postOrderValues = _avlTree.postOrderTraversal(_avlTree.root);
      } else {
        postOrderValues.clear();
      }
    });
  }

  // Construye una columna con un botón y una lista de valores
  Widget _buildColumn(String buttonText, List<int> values, bool showValues,
      VoidCallback onPressed) {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText,
                style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(23, 32, 33, 01)),
          ),
          if (showValues) ...[
            SizedBox(height: 10),
            Text('$buttonText: ${values.join(', ')}'),
          ],
        ],
      ),
    );
  }
}

// Clase para pintar el árbol en el lienzo
class TreePainter extends CustomPainter {
  final Node? root;
  final double nodeRadius = 25.0;

  TreePainter(this.root);

  @override
  void paint(Canvas canvas, Size size) {
    if (root == null) return;

    _paintNode(canvas, root!, Offset(size.width / 2, 50), size.width / 2);

    _drawEdges(canvas, root!, Offset(size.width / 2, 50), size.width / 2);
  }

  void _paintNode(Canvas canvas, Node node, Offset position, double width) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 0, 102, 255)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;
      //Cambio de color nodo

    canvas.drawCircle(position, nodeRadius, paint);

    final textSpan = TextSpan(
      text: node.key.toString(),
      style: TextStyle(color: Color.fromARGB(255, 253, 253, 252)),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  void _drawEdges(Canvas canvas, Node node, Offset position, double width) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 4, 226, 15)
      ..strokeWidth = 3.0;
      //Cambiar color de linea que conecta los nodos

    final gap = width / 2;
    final nodeBottom = position.dy + nodeRadius;

    if (node.left != null) {
      final leftParentPosition = Offset(position.dx, position.dy + nodeRadius);
      final leftChildPosition = Offset(position.dx - gap, nodeBottom + 100);
      final controlPoint = Offset(
        (leftParentPosition.dx + leftChildPosition.dx) / 2,
        leftParentPosition.dy + 50,
      );

      canvas.drawLine(leftParentPosition, controlPoint, paint);
      canvas.drawLine(controlPoint, leftChildPosition, paint);

      _paintNode(canvas, node.left!, leftChildPosition, gap);
      _drawEdges(canvas, node.left!, leftChildPosition, gap);
    }

    if (node.right != null) {
      final rightParentPosition = Offset(position.dx, position.dy + nodeRadius);
      final rightChildPosition = Offset(position.dx + gap, nodeBottom + 100);
      final controlPoint = Offset(
        (rightParentPosition.dx + rightChildPosition.dx) / 2,
        rightParentPosition.dy + 50,
      );

      canvas.drawLine(rightParentPosition, controlPoint, paint);
      canvas.drawLine(controlPoint, rightChildPosition, paint);

      _paintNode(canvas, node.right!, rightChildPosition, gap);
      _drawEdges(canvas, node.right!, rightChildPosition, gap);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}