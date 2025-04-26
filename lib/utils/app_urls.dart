// Dart and Flutter packages
export 'dart:io';
export 'dart:async';
export 'package:flutter/material.dart';

// Firebase packages
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_storage/firebase_storage.dart';

// GetX and other packages
export 'package:get/get.dart' hide HeaderValue;
export 'package:shared_preferences/shared_preferences.dart';
export 'package:uuid/uuid.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:fl_chart/fl_chart.dart';

// Models
export 'package:healty_ways/model/assigned_medication_model.dart';
export 'package:healty_ways/model/appointment_model.dart';
export 'package:healty_ways/model/chat_room_model.dart';
export 'package:healty_ways/model/doctor_model.dart';
export 'package:healty_ways/model/message_model.dart';
export 'package:healty_ways/model/patient_model.dart';
export 'package:healty_ways/model/pharmacist_model.dart';
export 'package:healty_ways/model/user_model.dart';
export 'package:healty_ways/model/inventory_model.dart';
export 'package:healty_ways/model/medicine_model.dart';
export 'package:healty_ways/model/order_model.dart';
export 'package:healty_ways/model/medication_model.dart';
export 'package:healty_ways/model/allergy_model.dart';
export 'package:healty_ways/model/immunization_model.dart';
export 'package:healty_ways/model/diary_entry_model.dart';
export 'package:healty_ways/model/order_meds_model.dart';
export 'package:healty_ways/model/lab_report_model.dart';

// ViewModels
export 'package:healty_ways/view_model/appointments_view_model.dart';
export 'package:healty_ways/view_model/profile_view_model.dart';
export 'package:healty_ways/view_model/chat_view_model.dart';
export 'package:healty_ways/view_model/order_view_model.dart';
export 'package:healty_ways/view_model/medicine_view_model.dart';
export 'package:healty_ways/view_model/inventory_view_model.dart';
export 'package:healty_ways/view_model/pharmacist_view_model.dart';
export 'package:healty_ways/view_model/patients_view_model.dart';
export 'package:healty_ways/view_model/auth_view_model.dart';
export 'package:healty_ways/view_model/assigned_medication_view_model.dart';
export 'package:healty_ways/view_model/health_records_view_model.dart';
export 'package:healty_ways/view_model/doctors_view_model.dart';
export "package:healty_ways/view_model/lab_reports_view_model.dart";

// Views
export 'package:healty_ways/view/doctor/doctor_assigned_patient_details_view.dart'
    hide MedicationCard;

// Patient Views
export 'package:healty_ways/view/patient/patient_allergy_view.dart';
export 'package:healty_ways/view/patient/patient_appointment_history_view.dart';
export 'package:healty_ways/view/patient/appointment_report_view.dart';
export 'package:healty_ways/view/patient/book_doctor_details_view.dart';
export 'package:healty_ways/view/patient/book_doctor_view.dart';
export 'package:healty_ways/view/patient/home_view.dart';
export 'package:healty_ways/view/patient/inventory_add_item_view.dart';
export 'package:healty_ways/view/patient/inventory_view.dart';
export 'package:healty_ways/view/patient/medication_history_view.dart';
export 'package:healty_ways/view/patient/patient_appointment_start_view.dart';
export 'package:healty_ways/view/patient/patient_contact_pharmacist_view.dart';
export 'package:healty_ways/view/patient/patient_diary_enteries_view.dart';
export 'package:healty_ways/view/patient/patient_immunization_view.dart';
export 'package:healty_ways/view/patient/patient_orders_details_view.dart';
export 'package:healty_ways/view/patient/patient_profile_view.dart';
export 'package:healty_ways/view/patient/patient_orders_view.dart';
export 'package:healty_ways/view/patient/request_medicne_view.dart';
export 'package:healty_ways/view/patient/patient_book_appointment.dart';

// Doctor Views
export 'package:healty_ways/view/doctor/doctor_allergy_view.dart';
export 'package:healty_ways/view/doctor/doctor_appointment_history_details_view.dart';
export 'package:healty_ways/view/doctor/doctor_appointment_start_view.dart';
export 'package:healty_ways/view/doctor/doctor_appointments_view.dart';
export 'package:healty_ways/view/doctor/doctor_assigned_patient_details_view.dart';
export 'package:healty_ways/view/doctor/doctor_assigned_patients_view.dart';
export 'package:healty_ways/view/doctor/doctor_home_view.dart';
export 'package:healty_ways/view/doctor/doctor_immunization_view.dart';
export 'package:healty_ways/view/doctor/doctor_medicine_assign_view.dart';
export 'package:healty_ways/view/doctor/doctor_profile_view.dart';

// Pharmacist Views
export 'package:healty_ways/view/pharmacy/pharmacy_orders_request_view.dart'
    hide CustomElevatedButton;
export 'package:healty_ways/view/pharmacy/pharmacy_create_order_view.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_home_view.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_inventory_add_item_view.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_profile_view.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_inventory_view.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_lab_records.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_order_details_view.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_delivery_status_view.dart';
export 'package:healty_ways/view/pharmacy/pharmacy_upload_lab_report_view.dart';

// Shared Views
export 'package:healty_ways/view/shared/chat_list_view.dart';
export 'package:healty_ways/view/shared/chats_view.dart';
export 'package:healty_ways/view/shared/one_to_one_chats_list_view.dart';
export 'package:healty_ways/view/shared/chat_view.dart';
export 'package:healty_ways/resources/components/shared/chat_component.dart';
export 'package:healty_ways/view/shared/all_medicine_view.dart';
export 'package:healty_ways/view/shared/auth/login_view.dart';
export 'package:healty_ways/view/shared/auth/signup_view.dart';
export 'package:healty_ways/view/shared/diary_entery_view.dart';
export 'package:healty_ways/view/shared/splash_view.dart';

// Resources
export 'package:healty_ways/resources/app_colors.dart';
export 'package:healty_ways/resources/app_end_points.dart';

// Reusable Widgets
export 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
export 'package:healty_ways/resources/widgets/reusable_elevated_button.dart';
export 'package:healty_ways/resources/widgets/reusable_text_field.dart';

// Components
export 'package:healty_ways/resources/components/shared/appointment_profile_card.dart';
export 'package:healty_ways/resources/components/shared/home_button.dart';
export 'package:healty_ways/resources/components/doctor/assign_medicine_popup.dart';
export 'package:healty_ways/resources/components/shared/reusable_user_profile_card.dart';
export 'package:healty_ways/resources/components/pharmacy/orders_summary_chart.dart';
export 'package:healty_ways/resources/components/patient/build_calendar.dart'
    hide BuildCalendar;
export 'package:healty_ways/resources/components/patient/medication_card.dart'
    hide MedicationCard;
export 'package:healty_ways/resources/components/doctor/doctors_appointments_card.dart';
export 'package:healty_ways/resources/components/patient/allergy_card.dart';
export 'package:healty_ways/resources/components/patient/immunization_card.dart';
export 'package:healty_ways/model/medicine_schedule_model.dart';
export 'package:healty_ways/resources/components/patient/doctor_card.dart';
export 'package:healty_ways/resources/components/patient/inventory_medicne_card.dart';

// Utils
export 'package:healty_ways/utils/utils.dart';
export 'package:healty_ways/utils/routes/route_name.dart';
export 'package:healty_ways/utils/routes/routes.dart';
