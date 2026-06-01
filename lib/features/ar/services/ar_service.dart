import '../../../core/services/supabase_service.dart';
import '../models/ar_model.dart';

class ARService {
  /// Mencari AR model berdasarkan QR code yang di-scan
  Future<ARModelModel?> getARModelByQR(String qrCode) async {
    try {
      final data = await supabase
          .from('ar_models')
          .select()
          .eq('qr_code', qrCode)
          .eq('is_active', true)
          .single();
      return ARModelModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Mengambil semua AR model aktif (untuk preview list)
  Future<List<ARModelModel>> getAllARModels() async {
    try {
      final data = await supabase
          .from('ar_models')
          .select()
          .eq('is_active', true)
          .order('nama');
      return (data as List).map((j) => ARModelModel.fromJson(j)).toList();
    } catch (e) {
      return [];
    }
  }
}
