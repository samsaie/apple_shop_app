// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BasketItemAdapter extends TypeAdapter<BasketItem> {
  @override
  final int typeId = 0;

  @override
  BasketItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasketItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
      fields[4] as String,
      fields[5] as int,
      fields[6] as String,
    )
      ..realPrice = fields[7] as int?
      ..persent = fields[8] as num?;
  }

  @override
  void write(BinaryWriter writer, BasketItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.collectionId)
      ..writeByte(2)
      ..write(obj.discountPrice)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.thumbnail)
      ..writeByte(7)
      ..write(obj.realPrice)
      ..writeByte(8)
      ..write(obj.persent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasketItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
