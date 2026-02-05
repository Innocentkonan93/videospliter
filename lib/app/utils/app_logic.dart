class SelectionLogic {
  /// Bascule l'état de sélection d'un élément dans une liste.
  /// Ajoute l'élément s'il n'est pas présent, le retire sinon.
  static List<T> toggleSelection<T>(List<T> currentSelection, T item) {
    final newSelection = List<T>.from(currentSelection);
    if (newSelection.contains(item)) {
      newSelection.remove(item);
    } else {
      newSelection.add(item);
    }
    return newSelection;
  }

  /// Gère la sélection "Tout sélectionner" / "Tout désélectionner".
  /// Si la sélection est vide, sélectionne tout. Sinon, vide la sélection.
  static List<T> toggleSelectAll<T>(
    List<T> currentSelection,
    List<T> allItems,
  ) {
    if (currentSelection.isEmpty) {
      return List<T>.from(allItems);
    } else {
      return <T>[];
    }
  }
}

class AdLogic {
  /// Détermine si une publicité récompensée doit être affichée (tous les N éléments).
  static bool shouldShowRewardedAd(int counter, int frequency) {
    if (counter <= 0) return false;
    return counter % frequency == 0;
  }

  /// Détermine si une demande de notation doit être faite (tous les N éléments).
  static bool shouldAskForRating(int counter, int frequency) {
    if (counter <= 0) return false;
    return counter % frequency == 0;
  }
}
