const bcrypt = require('./FinanzasBackend/node_modules/bcryptjs');

const generateHash = async (password) => {
  const saltRounds = 10; // El mismo número de rondas que usamos en el backend
  const hashedPassword = await bcrypt.hash(password, saltRounds);
  return hashedPassword;
};

(async () => {
  const superAdminPassword = 'super_admin_password_hash';
  const adminPassword = 'admin_password_hash';

  const hashedSuperAdmin = await generateHash(superAdminPassword);
  const hashedAdmin = await generateHash(adminPassword);

  console.log(`Hashed Super Admin Password: ${hashedSuperAdmin}`);
  console.log(`Hashed Admin Password: ${hashedAdmin}`);
})();
