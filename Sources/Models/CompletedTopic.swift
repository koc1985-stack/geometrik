import Foundation
import SwiftData

/// Bir kullanıcının tamamladığı konu - SwiftData ile yerel depolanır, CloudKit `.automatic`
/// sayesinde aynı Apple hesabındaki diğer cihazlarla otomatik senkronize olur. Ayrı bir
/// backend/hesap sistemi yok; kimlik tamamen kullanıcının iCloud hesabına bağlı.
@Model
final class CompletedTopic {
    /// `Topic.id` ile eşleşir (örn. "lgs.ucgen-temel"). NOT: `@Attribute(.unique)` KASITLI
    /// OLARAK kullanılmıyor - CloudKit senkronizasyonu unique constraint'leri desteklemiyor
    /// (ModelContainer oluşturulurken çökmeye yol açar). Bir konu birden fazla kez tamamlanırsa
    /// (kullanıcı dersi tekrar çözerse) birden fazla kayıt oluşabilir - bu kasıtlı, bir tür
    /// tamamlama geçmişi olarak düşünülebilir; `completedIds` gibi sorgular zaten `Set` ile
    /// tekilleştiriyor.
    var topicId: String
    var completedAt: Date
    /// Kavrama kontrolündeki doğru sayısı / toplam soru - ilerleme özetinde gösterilir.
    var correctCount: Int
    var totalQuestions: Int

    init(topicId: String, completedAt: Date = .now, correctCount: Int, totalQuestions: Int) {
        self.topicId = topicId
        self.completedAt = completedAt
        self.correctCount = correctCount
        self.totalQuestions = totalQuestions
    }
}
