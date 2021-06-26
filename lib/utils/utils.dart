import '../entities/record.dart';

import '../entities/help.dart';
import '../entities/item.dart';

String fmtDate(DateTime d) {
  return "${d.day}/${d.month}/${d.year}";
}

int totalHelpCount(List<Help> lh) {
  int totalCount = 0;
  if (lh.length == 0 || lh == null) {
    return 0;
  }
  for (Help h in lh) {
    totalCount += h.count;
  }
  return totalCount;
}

int totalGettingHelp(List<Item> items) {
  int totalGettingHelp = 0;
  for (Item i in items) {
    totalGettingHelp += totalHelpCount(i.gettingHelp);
  }
  return totalGettingHelp;
}

int totalNeedToHelp(List<Item> items) {
  int totalNeedToHelp = 0;
  for (Item i in items) {
    totalNeedToHelp += totalHelpCount(i.needToHelpBack);
  }
  return totalNeedToHelp;
}

int subHelpCount(Item i) {
  return totalHelpCount(i.gettingHelp) - totalHelpCount(i.needToHelpBack);
}

int pay(Item i, double price) {
  //int totalPaid=0;
  //totalPaid = subHelpCount(i) * price.toInt();
//  var totalpaid=subHelpCount(i) * price.toInt();
  //return totalpaid < 0 ? -totalpaid : totalpaid;
  return subHelpCount(i) * price.toInt();
}

int sortByDate(Record a, Record b) {
  return a.timeStamp.compareTo(b.timeStamp);
}
int itemSortBytDate(Item a, Item b){
  return a.created.compareTo(b.created);
}
int sortByisDone(Item a, Item b) {
  return a.isfinished.toString().compareTo(b.isfinished.toString());
}

List<Item> filterByDate(List<Item> items, DateTime time) {
  Set<Item> filtered = {};
  for (Item i in items) {
    List<Help> lh = [];
    Item newItem = Item();
    //newItem.needToHelpBack.clear();
    for (Help h in i.needToHelpBack) {
      if (h.timeStamp.day == time.day) {
        lh.add(h);
        // filtered.add(i);
        continue;
      }
    }
    newItem.name=i.name;
    newItem.needToHelpBack = lh;
    if (lh.length > 0) {
      filtered.add(newItem);
    }
  }
  return filtered.toList();
}
