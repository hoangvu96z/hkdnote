import '../models/inventory_item.dart';
import '../models/payroll_record.dart';
import '../models/transaction.dart';

class SampleData {
  static List<Transaction> transactions() {
    return [
      Transaction(
        id: 't1',
        date: DateTime(2024, 12, 1),
        amount: 1200000,
        type: TransactionType.income,
        category: 'Bán hàng',
        account: 'Tiền mặt',
        note: 'Bán lẻ buổi sáng',
        documentNumber: 'S1-001',
        taxType: TaxType.output,
      ),
      Transaction(
        id: 't2',
        date: DateTime(2024, 12, 2),
        amount: 450000,
        type: TransactionType.expense,
        category: 'Nhập hàng',
        account: 'Ngân hàng BIDV',
        note: 'Nhập 10 thùng nước ngọt',
        documentNumber: 'S2-015',
        taxType: TaxType.input,
      ),
      Transaction(
        id: 't3',
        date: DateTime(2024, 12, 2),
        amount: 180000,
        type: TransactionType.expense,
        category: 'Chi phí vận chuyển',
        account: 'Tiền mặt',
        note: 'Giao hàng nội thành',
        documentNumber: '',
      ),
      Transaction(
        id: 't4',
        date: DateTime(2024, 12, 3),
        amount: 2300000,
        type: TransactionType.income,
        category: 'Bán sỉ',
        account: 'Ngân hàng VCB',
        note: 'Hóa đơn 432',
        documentNumber: 'S1-002',
        taxType: TaxType.output,
      ),
    ];
  }

  static List<InventoryItem> inventoryItems() {
    return const [
      InventoryItem(
        id: 'i1',
        name: 'Nước ngọt',
        quantity: 18,
        unitCost: 120000,
        unitPrice: 150000,
        minStock: 8,
      ),
      InventoryItem(
        id: 'i2',
        name: 'Bánh mì',
        quantity: 3,
        unitCost: 90000,
        unitPrice: 120000,
        minStock: 5,
      ),
      InventoryItem(
        id: 'i3',
        name: 'Sữa tươi',
        quantity: 6,
        unitCost: 180000,
        unitPrice: 210000,
        minStock: 4,
      ),
    ];
  }

  static List<PayrollRecord> payrollRecords() {
    return const [
      PayrollRecord(
        id: 'p1',
        employeeName: 'Nguyễn Văn B',
        baseSalary: 6000000,
        workingDays: 22,
        totalWorkingDays: 26,
        allowance: 300000,
        deduction: 150000,
        isPaid: true,
      ),
      PayrollRecord(
        id: 'p2',
        employeeName: 'Trần Thị C',
        baseSalary: 5500000,
        workingDays: 20,
        totalWorkingDays: 26,
        allowance: 200000,
        deduction: 120000,
        isPaid: false,
      ),
    ];
  }
}
