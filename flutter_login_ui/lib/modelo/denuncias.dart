import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Denuncia {
  String id;
  String nombre;
  String descripcion;
  GeoPoint ubicacion;
  String tipo;
  String imagen;

  Denuncia();
  Denuncia.fromMap(Map<String, dynamic> data){
    id= data['id'];
    nombre= data['nombre'];
    descripcion= data['descripcion'];
    ubicacion= data['ubicacion'];
    tipo= data['tipo'];
    imagen= data['imagen'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'ubicacion': ubicacion,
      'tipo': tipo
    };
  }
}

