import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuego_defi_types/fuego_defi_type_utils.dart';

part 'confirm_address_details.freezed.dart';
part 'confirm_address_details.g.dart';

/// Details returned when the hardware wallet asks to confirm an address.
@freezed
abstract class ConfirmAddressDetails with _$ConfirmAddressDetails {
  const factory ConfirmAddressDetails({
    @JsonKey(name: 'expected_address') required String expectedAddress,
  }) = _ConfirmAddressDetails;

  factory ConfirmAddressDetails.fromJson(JsonMap json) =>
      _$ConfirmAddressDetailsFromJson(json);
}
