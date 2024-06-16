import 'package:flutter/material.dart';

class ConfigShareFile extends StatefulWidget {
  final Widget? IconFile;
  final String? FileName;
  final String? receiver_name;
  final Function(int)? onDone;

  const ConfigShareFile(
      {Key? key, this.onDone, this.IconFile, this.FileName, this.receiver_name})
      : super(key: key);

  @override
  State<ConfigShareFile> createState() => _ConfigShareFileState();
}

class _ConfigShareFileState extends State<ConfigShareFile> {
  List<DropdownMenuItem<int>> items = [
    DropdownMenuItem(
      child: Text('Chỉ xem'),
      value: 17,
    ),
    DropdownMenuItem(
      child: Text('Có thể chỉnh sửa'),
      value: 19,
    ),
  ];
  int permission = 19;

  @override
  Widget build1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chia sẻ file'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('File chia sẻ'),
              Row(
                children: [
                  widget.IconFile ?? Icon(Icons.file_present),
                  const SizedBox(width: 10),
                  Text(widget.FileName ?? ''),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Chia sẻ cho'),
              const SizedBox(height: 10),
              Text(widget.receiver_name ?? ''),
              const SizedBox(height: 20),
              const Text('Chọn quyền truy cập'),
              const SizedBox(height: 10),
              DropdownButton(items: items,
                value: permission,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    permission = value!;
                  });
                },),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.onDone?.call(permission);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Chia sẻ'),
              ),
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chia sẻ file'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                  child: Text(
                      'File chia sẻ', style: theme.textTheme.titleMedium),
                ),
                ListTile(
                  leading: widget.IconFile ?? Icon(Icons.file_present),
                  title: Text(widget.FileName ?? '',
                      style: theme.textTheme.titleMedium),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Chia sẻ cho', style: theme.textTheme.titleMedium)),
                ListTile(
                  leading: Icon(Icons.person,size: 30,),
                  title: Text(widget.receiver_name ?? '',
                      style: theme.textTheme.titleMedium),
                ),
              ],
            )),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5
                    ),
                    child: Text('Quyền truy cập',
                        style: theme.textTheme.titleMedium),
                  ),
                  Row(
                    children: [
                      Icon(Icons.lock,size: 30,),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          items: items,
                          value: permission,
                          onChanged: (value) {
                            setState(() {
                              permission = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: theme.elevatedButtonTheme.style?.copyWith(
                side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
              ),
              onPressed: () {
                widget.onDone?.call(permission);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: IntrinsicWidth(child: const Text('Chia sẻ')),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
