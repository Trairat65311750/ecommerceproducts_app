import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ecommerceproducts_app/provider/productProvider.dart';
import 'package:ecommerceproducts_app/model/productItem.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  DateTime? selectedDate;
  String? selectedCategory;
  File? imageFile;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('เพิ่มสินค้า'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("เพิ่มสินค้า",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(),
                    const SizedBox(height: 10),

                    // ปุ่มเลือกรูปภาพ
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: imageFile == null
                            ? const Center(child: Text("เลือกภาพสินค้า"))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    Image.file(imageFile!, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // ชื่อสินค้า
                    TextFormField(
                      controller: productNameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อสินค้า',
                        prefixIcon: const Icon(Icons.shopping_bag),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'กรุณาป้อนชื่อสินค้า' : null,
                    ),
                    const SizedBox(height: 15),

                    // ฟิลด์สำหรับเลือกวันที่
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'วันที่',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          selectedDate == null
                              ? 'ยังไม่ได้เลือกวันที่'
                              : '${selectedDate!.toLocal()}'.split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // ราคา
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ราคา',
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) =>
                          (value == null || double.tryParse(value) == null)
                              ? 'กรุณาป้อนราคาให้ถูกต้อง'
                              : null,
                    ),
                    const SizedBox(height: 15),

                    // Dropdown เลือกหมวดหมู่
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: [
                        'อิเล็กทรอนิกส์',
                        'เสื้อผ้า & แฟชั่น',
                        'ความงาม & เครื่องสำอาง',
                        'สุขภาพ & อาหารเสริม',
                        'ของใช้ในบ้าน',
                        'คอมพิวเตอร์ & เกม',
                      ]
                          .map((category) => DropdownMenuItem(
                              value: category, child: Text(category)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedCategory = value),
                      decoration: InputDecoration(
                        labelText: 'หมวดหมู่',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) =>
                          value == null ? 'กรุณาเลือกหมวดหมู่' : null,
                    ),
                    const SizedBox(height: 15),

                    // จำนวนสินค้าในสต็อก
                    TextFormField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'จำนวนในสต็อก',
                        prefixIcon: const Icon(Icons.inventory),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) =>
                          (value == null || int.tryParse(value) == null)
                              ? 'กรุณาป้อนจำนวนให้ถูกต้อง'
                              : null,
                    ),
                    const SizedBox(height: 20),

                    // FloatingActionButton
                    Align(
                      alignment: Alignment.center,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            var provider = Provider.of<ProductProvider>(context,
                                listen: false);
                            provider.addProduct(ProductItem(
                              productName: productNameController.text,
                              price: double.parse(priceController.text),
                              category: selectedCategory ?? "ไม่ระบุ",
                              stockQuantity: int.parse(stockController.text),
                              imagePath: imageFile?.path,
                            ));
                            Navigator.pop(context);
                          }
                        },
                        backgroundColor: Colors.deepPurple,
                        label: const Text("เพิ่มสินค้า",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        icon: const Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
