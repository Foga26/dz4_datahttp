import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await _startScan();
    super.didChangeDependencies();
  }

  Future<void> _startScan() async {
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!devices.contains(r.device)) {
          devices.add(r.device);
          setState(() {});
        }
      }
    });

    flutterBlue.startScan();
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Устройства блютуз'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].type.toString()),
            subtitle: Text(devices[index].id.toString()),
          );
        },
      ),
    );
  }
}


/*Для запроса информации о доступных Bluetooth Low Energy (BLE) устройствах и отображения списка на странице профиля с помощью Pigeon, Dart и Flutter, вам понадобится выполнить следующие шаги:

Шаг 1: Подключение пакетов
Перейдите в файл pubspec.yaml в вашем проекте Flutter и добавьте следующие зависимости:


yaml
dependencies:
  flutter_blue: ^0.7.3
  pigeon: ^0.1.3


Затем запустите flutter pub get, чтобы загрузить зависимости.

Шаг 2: Создание Pigeon API
Создайте файл ble_pigeon.dart и добавьте следующий код:

dart
import 'package:pigeon/pigeon.dart';

class BleDevice {
  String? name;
  String? id;
}

@HostApi()
abstract class BleApi {
  void startScan();
  
  void stopScan();
  
  List<BleDevice> getDevices();
  
  @async
  BleDevice connectToDevice(String deviceId);
  
  @async
  bool disconnectFromDevice(String deviceId);
}

@FlutterApi()
abstract class ProfileApi {
  void updateDevices(List<BleDevice> devices);
}

void configurePigeon(PigeonOptions options) {
  options.dartOut = 'lib/src/generated/ble_api.dart';
  options.dartTestOut = 'test/src/generated/ble_api_mock.dart';
  options.objcHeaderOut = 'ios/Runner/BleApi.h';
  options.objcSourceOut = 'ios/Runner/BleApi.m';
  options.javaOut = 'android/app/src/main/java/com/example/bleapi/BleApi.java';
}


Шаг 3: Генерация API
Запустите генерацию API с помощью следующей команды:

bash
flutter pub run pigeon \
    --input lib/src/ble_pigeon.dart \
    --dart_out lib/src/generated \
    --objc_header_out ios/Runner \
    --objc_source_out ios/Runner \
    --java_out android/app/src/main/java/com/example/bleapi


Обратите внимание, что вы должны настроить пути к файлу в соответствии с структурой проекта.

Шаг 4: Использование API в Flutter
Добавьте следующий код в файл main.dart вашего проекта Flutter:

dart
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pigeon/pigeon.dart';
import 'package:your_project_name/src/generated/ble_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BleApi _bleApi = BleApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('BLE Devices'),
        ),
        body: Container(
          child: FutureBuilder<List<BleDevice>>(
            future: _bleApi.getDevices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].name ?? 'Unknown'),
                        subtitle: Text(snapshot.data![index].id ?? ''),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}


Поздравляю! Теперь у вас есть Flutter-приложение, которое использует Pigeon API
 для запроса информации о доступных устройствах BLE и отображает список на странице профиля.
 */

















// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<BluetoothDevice> devices = [];

//   @override
//   void initState() {
//     super.initState();
//     _getDevices();
//   }

//   void _getDevices() async {
//     flutterBlue.scanResults.listen((results) {
//       setState(() {
//         for (ScanResult result in results) {
//           if (!devices.contains(result.device)) devices.add(result.device);
//         }
//       });
//     });
//     flutterBlue.startScan();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Page'),
//       ),
//       body: ListView.builder(
//         itemCount: devices.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(devices[index].name),
//             subtitle: Text(devices[index].id.toString()),
//           );
//         },
//       ),
//     );
//   }
// }




/*   
Для запроса информации о доступных Bluetooth Low Energy (BLE) устройствах через плагин в Flutter, вы можете использовать пакет flutter_blue. Вот как вы можете это сделать:

1. Добавьте зависимость пакета flutter_blue в ваш файл pubspec.yaml:


yaml
dependencies:
  flutter_blue: ^0.7.3


2. Запустите команду flutter packages get, чтобы загрузить зависимости вашего проекта.

3. Импортируйте нужные классы в ваш файл Dart:

dart
import 'package:flutter_blue/flutter_blue.dart';


4. Создайте экземпляр класса FlutterBlue:

dart
FlutterBlue flutterBlue = FlutterBlue.instance;


5. В вашем классе страницы профиля, вы можете использовать следующий код для отображения списка доступных BLE устройств:

dart
List<BluetoothDevice> devicesList = [];

@override
void initState() {
  super.initState();
  
  // Подписка на обновления состояния Bluetooth
  flutterBlue.state.listen((state) {
    if (state == BluetoothState.on) {
      // Bluetooth включен
      
      // Сканирование BLE устройств
      flutterBlue.scanResults.listen((results) {
        for (ScanResult result in results) {
          // Добавление найденных устройств в список
          if (!devicesList.contains(result.device)) {
            setState(() {
              devicesList.add(result.device);
            });
          }
        }
      });
      
      // Запуск сканирования
      flutterBlue.startScan();
    } else if (state == BluetoothState.off) {
      // Bluetooth выключен
      
      // Остановка сканирования
      flutterBlue.stopScan();
    }
  });
}

// Отображение списка устройств на странице профиля
ListView.builder(
  itemCount: devicesList.length,
  itemBuilder: (BuildContext context, int index) {
    BluetoothDevice device = devicesList[index];
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.id.toString()),
      onTap: () {
        // Действия при нажатии на устройство
      },
    );
  },
)

*/
