import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String format(String pattern, {String locale = 'en'}) {
    return DateFormat(pattern, locale).format(this);
  }
}


// ======================================================
// 🗓 YEAR
// ======================================================
// y      -> Year (min digits)             2026
// yy     -> 2-digit year                  26
// yyy    -> Year (3+ digits)              2026
// yyyy   -> 4-digit year                  2026
// yyyyy  -> 5-digit year                  02026

// ======================================================
// 📅 MONTH
// ======================================================
// M      -> Month number                  3
// MM     -> 2-digit month                 03
// MMM    -> Short month name              Mar
// MMMM   -> Full month name               March
// MMMMM  -> Narrow month                  M

// ======================================================
// 📆 DAY
// ======================================================
// d      -> Day number                    2
// dd     -> 2-digit day                   02

// ======================================================
// 📅 WEEKDAY
// ======================================================
// E      -> Short weekday                 Mon
// EEEE   -> Full weekday                  Monday
// EEEEE  -> Narrow weekday                M

// ======================================================
// ⏰ HOUR (24-Hour Format)
// ======================================================
// H      -> Hour (0-23)                   9
// HH     -> 2-digit hour                  09

// ======================================================
// ⏰ HOUR (12-Hour Format)
// ======================================================
// h      -> Hour (1-12)                   9
// hh     -> 2-digit hour                  09
// a      -> AM / PM marker                AM

// ======================================================
// 🕐 MINUTES
// ======================================================
// m      -> Minutes                       7
// mm     -> 2-digit minutes               07

// ======================================================
// ⏱ SECONDS
// ======================================================
// s      -> Seconds                       4
// ss     -> 2-digit seconds               04

// ======================================================
// ⏳ FRACTIONAL SECONDS
// ======================================================
// S      -> Milliseconds (1 digit)
// SS     -> Milliseconds (2 digits)
// SSS    -> Milliseconds (3 digits)

// ======================================================
// 🌍 TIMEZONE (Limited support in Flutter)
// ======================================================
// z      -> Short timezone name
// Z      -> RFC 822 timezone
// X      -> ISO 8601 timezone

// ======================================================
// ⚠️ IMPORTANT NOTES
// ======================================================
// MM  !=  mm   -> MM = Month, mm = Minutes
// HH  !=  hh   -> HH = 24-hour, hh = 12-hour
// Pattern is case-sensitive
// Locale affects MMM, MMMM, EEEE