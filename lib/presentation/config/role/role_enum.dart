enum RoleBaseEnum {
  OWNER('Chủ sở hữu', 'OWNER'),
  ADMINWS('Admin Workspace', 'ADMINWS'),
  ADMINBR('Admin Cơ sở', 'ADMINBR'),
  MANAEBR('Quản lý Cơ sở', 'MANAEBR'),
  PHARMACIST('Dược sĩ', 'PHARMACIST'),
  DOCTOR('Bác sĩ', 'DOCTOR'),
  NURSE('Y tá', 'NURSE'),
  ACCOUNTANT_CASHIER('Kế toán/thu ngân', 'ACCOUNTANT/CASHIER');

  final String title;
  final String code;
  const RoleBaseEnum(this.title, this.code);
}
