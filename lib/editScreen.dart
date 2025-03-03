import 'dart:io';
import 'package:ecommerceproducts_app/model/productItem.dart';
import 'package:ecommerceproducts_app/provider/productProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final int index;
  final ProductItem product;

  const EditScreen({super.key, required this.index, required this.product});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  String? selectedCategory;
  File? imageFile; // สำหรับรูปภาพใหม่

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // ตั้งค่า TextEditingController จากข้อมูลสินค้าเดิม
    productNameController = TextEditingController(text: widget.product.productName);
    priceController = TextEditingController(text: widget.product.price.toString());
    stockController = TextEditingController(text: widget.product.stockQuantity.toString());
    selectedCategory = widget.product.category;

    // ถ้าสินค้ามี imagePath อยู่แล้ว ให้แสดงภาพเดิม
    if (widget.product.imagePath != null) {
      imageFile = File(widget.product.imagePath!);
    }
  }

  // ฟังก์ชันเลือกรูปภาพใหม่
  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
        title: const Text('แก้ไขสินค้า'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    "แก้ไขสินค้า",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),

                  // ส่วนเลือกรูปภาพ
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: imageFile == null
                          ? const Center(child: Text("ยังไม่มีรูปภาพ"))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(imageFile!, fit: BoxFit.cover),
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => value!.isEmpty ? 'กรุณาป้อนชื่อสินค้า' : null,
                  ),
                  const SizedBox(height: 15),

                  // ราคา
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'ราคา',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'กรุณาป้อนราคา';
                      if (double.tryParse(value) == null) return 'กรุณาป้อนตัวเลขเท่านั้น';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // หมวดหมู่
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: const [
                      DropdownMenuItem(value: 'อิเล็กทรอนิกส์', child: Text('อิเล็กทรอนิกส์')),
                      DropdownMenuItem(value: 'เสื้อผ้า & แฟชั่น', child: Text('เสื้อผ้า & แฟชั่น')),
                      DropdownMenuItem(value: 'ความงาม & เครื่องสำอาง', child: Text('ความงาม & เครื่องสำอาง')),
                      DropdownMenuItem(value: 'สุขภาพ & อาหารเสริม', child: Text('สุขภาพ & อาหารเสริม')),
                      DropdownMenuItem(value: 'ของใช้ในบ้าน', child: Text('ของใช้ในบ้าน')),
                      DropdownMenuItem(value: 'คอมพิวเตอร์ & เกม', child: Text('คอมพิวเตอร์ & เกม')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'หมวดหมู่',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // จำนวนสต็อก
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'จำนวนในสต็อก',
                      prefixIcon: const Icon(Icons.inventory),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'กรุณาป้อนจำนวนสต็อก';
                      if (int.tryParse(value) == null) return 'กรุณาป้อนตัวเลขเท่านั้น';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ปุ่มบันทึก
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var provider = Provider.of<ProductProvider>(context, listen: false);
                        provider.updateProduct(
                          widget.index,
                          ProductItem(
                            keyID: widget.product.keyID, // ถ้ามี keyID เดิม
                            productName: productNameController.text,
                            price: double.parse(priceController.text),
                            category: selectedCategory ?? "ไม่ระบุ",
                            stockQuantity: int.parse(stockController.text),
                            // ถ้าไม่เลือกรูปใหม่ จะยังคงรูปเดิม
                            imagePath: imageFile?.path ?? widget.product.imagePath,
                            // รักษา date เดิม ถ้าจำเป็น
                            date: widget.product.date,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('บันทึก', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
