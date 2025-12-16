import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../../servicios/usuario_actual.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';
import '../../dominio/entidades/usuario.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _imagenPerfil;
  bool _cargando = false;
  late FocusNode _keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    _cargarImagenGuardada();
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  Future<void> _cargarImagenGuardada() async {
    final usuarioActual = GetIt.instance.get<UsuarioActual>();
    final usuario = usuarioActual.usuario;

    if (usuario?.fotoPerfil != null && usuario!.fotoPerfil!.isNotEmpty) {
      try {
        // Decodificar Base64 a bytes
        final bytes = base64Decode(usuario.fotoPerfil!);
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/perfil_temp.jpg');
        await tempFile.writeAsBytes(bytes);

        setState(() {
          _imagenPerfil = tempFile;
        });
      } catch (e) {
        print('Error cargando imagen: $e');
      }
    }
  }

  Future<void> _guardarFotoPerfil() async {
    if (_imagenPerfil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una foto primero')),
      );
      return;
    }

    try {
      setState(() => _cargando = true);

      // Convertir imagen a Base64
      final bytes = await _imagenPerfil!.readAsBytes();
      final base64String = base64Encode(bytes);

      // Actualizar usuario
      final usuarioActual = GetIt.instance.get<UsuarioActual>();
      final usuario = usuarioActual.usuario!;

      final usuarioActualizado = Usuario(
        id: usuario.id,
        nombre: usuario.nombre,
        email: usuario.email,
        password: usuario.password,
        edad: usuario.edad,
        peso: usuario.peso,
        altura: usuario.altura,
        fotoPerfil: base64String,
      );

      // Guardar en BD
      final repositorio = GetIt.instance.get<RepositorioDeUsuario>();
      print(
        'DEBUG: Guardando usuario con fotoPerfil de ${base64String.length} bytes',
      );
      await repositorio.actualizarUsuario(usuarioActualizado);
      print('DEBUG: Usuario guardado en BD');

      // Actualizar usuario actual
      usuarioActual.setUsuario(usuarioActualizado);
      print('DEBUG: Usuario actual actualizado');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil guardada ✓')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _seleccionarImagen() async {
    try {
      setState(() => _cargando = true);

      final XFile? imagen = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (imagen != null) {
        setState(() {
          _imagenPerfil = File(imagen.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil actualizada'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _tomarFoto() async {
    try {
      setState(() => _cargando = true);

      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (foto != null) {
        setState(() {
          _imagenPerfil = File(foto.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto capturada'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al tomar foto: $e')));
      }
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _mostrarOpcionesImagen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Seleccionar Foto de Perfil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.blue),
                  title: const Text('Galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _seleccionarImagen();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text('Tomar Foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _tomarFoto();
                  },
                ),
                if (_imagenPerfil != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Eliminar Foto'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _imagenPerfil = null);
                    },
                  ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioActual = GetIt.instance.get<UsuarioActual>();
    final usuario = usuarioActual.usuario;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          context.go('/');
        }
      },
      child: RawKeyboardListener(
        focusNode: _keyboardFocusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
            context.go('/');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mi Perfil'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
              tooltip: 'Volver al menú',
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Sección de Foto de Perfil
                SizedBox(
                  height: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _cargando ? null : _mostrarOpcionesImagen,
                          child: Stack(
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.3),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                child:
                                    _imagenPerfil != null
                                        ? ClipOval(
                                          child: Image.file(
                                            _imagenPerfil!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : Icon(
                                          Icons.person,
                                          size: 70,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.deepOrange.shade400,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child:
                                      _cargando
                                          ? const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                          : Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          usuario?.nombre ?? 'Usuario',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          usuario?.email ?? 'email@example.com',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tarjetas de Información
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoCard(
                        context,
                        title: 'Nombre',
                        value: usuario?.nombre ?? 'No disponible',
                        icon: Icons.person,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      if (_imagenPerfil != null)
                        ElevatedButton.icon(
                          onPressed: _cargando ? null : _guardarFotoPerfil,
                          icon:
                              _cargando
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.save),
                          label: Text(
                            _cargando ? 'Guardando...' : 'Guardar Foto',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      if (_imagenPerfil != null) const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        title: 'Email',
                        value: usuario?.email ?? 'No disponible',
                        icon: Icons.email,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        title: 'ID de Usuario',
                        value: usuarioActual.id,
                        icon: Icons.badge,
                        isDark: isDark,
                        showCopy: true,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        title: 'Edad',
                        value:
                            usuario?.edad != null
                                ? usuario!.edad.toString()
                                : 'No especificado',
                        icon: Icons.cake,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        title: 'Altura',
                        value: '${usuario?.altura ?? 0} cm',
                        icon: Icons.height,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        title: 'Peso',
                        value: '${usuario?.peso ?? 0} kg',
                        icon: Icons.fitness_center,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                // Sección de Estadísticas
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información Adicional',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              label: 'Recetas',
                              value: '12',
                              icon: Icons.restaurant,
                            ),
                            _buildStatItem(
                              label: 'Dietas',
                              value: '5',
                              icon: Icons.local_dining,
                            ),
                            _buildStatItem(
                              label: 'Rutinas',
                              value: '3',
                              icon: Icons.calendar_month,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    bool showCopy = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade600, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showCopy)
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                // Aquí implementar copiar al portapapeles
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ID copiado al portapapeles'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue.shade400),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
