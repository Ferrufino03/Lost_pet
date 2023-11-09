import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_bloc.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_event.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_state.dart';
import 'package:firebase_crud/screens/AnimalRegistration/model/Animal.dart';
import 'package:firebase_crud/screens/UpLoadImage/ui/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimalRegistrationScreen extends StatefulWidget {
  const AnimalRegistrationScreen({super.key});

  @override
  State<AnimalRegistrationScreen> createState() =>
      _AnimalRegistrationScreenState();
}

class _AnimalRegistrationScreenState extends State<AnimalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _imageUrl = "";

  static String _option = "";

  final TextEditingController _animalType = TextEditingController();
  final TextEditingController _additionalInfo = TextEditingController();
  final TextEditingController _ubicacionDePerdida = TextEditingController();
  final TextEditingController _recompensa = TextEditingController();
  final TextEditingController _numeroDeReferencia = TextEditingController();

  void handleInputsState({required Animal animal}) {
    _imageUrl = animal.imageURL;
    _option.isEmpty
        ? _animalType.text = animal.animaltype
        : _option = animal.animaltype;
    _additionalInfo.text = animal.informacion;
    _ubicacionDePerdida.text = animal.infoubicacion;
    _recompensa.text = animal.recompensa;
    _numeroDeReferencia.text = animal.numref;
  }

  void popScreen() {
    Navigator.pop(context);
    BlocProvider.of<AnimalRegistrationBloc>(context).add(ResetStateEvent());
  }

  InputDecoration _decor(String label) {
    return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.all(10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Animal Perdido')),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AnimalRegistrationBloc, AnimalRegistrationState>(
              builder: (context, state) {
            if (state is AnimalRegistrationUpdate) {
              handleInputsState(animal: state.animal!);
              return _form();
            } else if (state is RegistrationSuccess) {
              popScreen();
            } else if (state is ResetState) {
              handleInputsState(animal: state.animal!);
              return _form();
            } else {
              return _form();
            }
            return const CircularProgressIndicator();
          })),
    );
  }

  Widget _form() {
    Widget form = Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 60, minWidth: 120),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                    child: _imageUrl.isEmpty
                        ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UpLoadImage()));
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 60,
                            ))
                        : Image.network(
                            _imageUrl,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ))),
          ),
          const SizedBox(
            height: 20,
          ),
          animalsType(),
          const SizedBox(height: 10),
          TextFormField(
            decoration: _decor('Información Adicional'),
            controller: _additionalInfo,
            onChanged: (value) => _handleInput(value, "_additionalInfo"),
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: _decor('Ubicación de Pérdida'),
            controller: _ubicacionDePerdida,
            onChanged: (value) => _handleInput(value, "_ubicacionDePerdida"),
            validator: (value) =>
                value!.isEmpty ? 'Por favor ingrese la ubicación' : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                decoration: _decor('Recompensa'),
                controller: _recompensa,
                onChanged: (value) => _handleInput(value, "_recompensa"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese una recompensa' : null,
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: TextFormField(
                decoration: _decor('Número de Referencia'),
                controller: _numeroDeReferencia,
                onChanged: (value) =>
                    _handleInput(value, "_numeroDeReferencia"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese un número' : null,
              )),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            child: const Text('Registrar'),
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Color del botón
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
    Widget scroll = SingleChildScrollView(child: form);
    return scroll;
  }

  Widget animalsType() {
    List<String> tiposDeAnimales = ['Perro', 'Gato', 'Pato', 'Conejo', 'Canario'];
    Set<String> animals = {"Seleccione el tipo de animal", ...tiposDeAnimales};
    List<DropdownMenuItem<String>> items = animals.map((e) {
      return DropdownMenuItem<String>(
          value: e, child: Text(e, overflow: TextOverflow.ellipsis));
    }).toList();

    Widget menu = DropdownButton(
      isDense: true,
      isExpanded: true,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      items: items,
      value:
          animals.contains(_option) ? _option : "Seleccione el tipo de animal",
      padding: const EdgeInsets.symmetric(vertical: 7),
      onChanged: (value) {
        setState(() {
          _option = value.toString() == "Seleccione el tipo de animal"
              ? ""
              : value.toString();
          _handleInput(_option, "_animalType");
        });
      },
    );
    Widget inputType = TextFormField(
      decoration: _decor('Tipo de animal'),
      controller: _animalType,
      onChanged: (value) {
        setState(() {
          _handleInput(value, "_animalType");
        });
      },
      keyboardType: TextInputType.text,
    );
    Widget wrapper = Row(
      children: [
        _animalType.text.isEmpty
            ? Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Radio del borde del contenedor
                      border: Border.all(
                        color: Colors.black12, // Color del borde
                        width: 1, // Ancho del borde
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 5, right: 15),
                    child: menu))
            : const SizedBox(),
        (_animalType.text.isEmpty && _option.isEmpty)
            ? const SizedBox(
                width: 30,
                child: Text("o",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)))
            : const SizedBox(),
        _option.isEmpty ? Expanded(child: inputType) : const SizedBox()
      ],
    );
    return wrapper;
  }

  void _handleInput(String input, String controller) {
    final animal = BlocProvider.of<AnimalRegistrationBloc>(context).animal;
    Map<String, dynamic> inputTypes = {
      "_animalType": (String text) => animal.animaltype = text,
      "_additionalInfo": (String text) => animal.informacion = text,
      "_ubicacionDePerdida": (String text) => animal.infoubicacion = text,
      "_recompensa": (String text) => animal.recompensa = text,
      "_numeroDeReferencia": (String text) => animal.numref = text,
    };
    if (inputTypes.containsKey(controller)) {
      inputTypes[controller](input);
      BlocProvider.of<AnimalRegistrationBloc>(context)
          .add(InputEvent(animal: animal));
    }
  }

  void _submitForm() async {
    final animal = BlocProvider.of<AnimalRegistrationBloc>(context).animal;
    if (_formKey.currentState!.validate() && animal.animaltype.isNotEmpty && animal.imageURL.isNotEmpty) {
      //_formKey.currentState!.save();
      BlocProvider.of<AnimalRegistrationBloc>(context).add(SubmitEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(animal.animaltype.isEmpty?"Indique el tipo de animal":"Suba una imagen por favor."),
        ),
      );
    }
  }
}
