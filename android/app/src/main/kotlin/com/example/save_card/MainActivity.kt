package com.example.save_card

import android.content.Intent
import android.provider.ContactsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "contact_intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "addContact") {
                try {
                    val contactData = call.arguments as? Map<String, Any>
                    if (contactData != null) {
                        launchContactIntent(contactData)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "Contact data is null", null)
                    }
                } catch (e: Exception) {
                    result.error("ERROR", "Failed to launch contact intent: ${e.message}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun launchContactIntent(contactData: Map<String, Any>) {
        val intent = Intent(ContactsContract.Intents.Insert.ACTION).apply {
            type = ContactsContract.RawContacts.CONTENT_TYPE

            // Add name
            val name = contactData["name"] as? String
            if (!name.isNullOrEmpty()) {
                putExtra(ContactsContract.Intents.Insert.NAME, name)
            }

            // Add phones (max 2)
            val phones = contactData["phones"] as? List<String>
            if (!phones.isNullOrEmpty()) {
                putExtra(ContactsContract.Intents.Insert.PHONE, phones[0])
                if (phones.size > 1) {
                    putExtra(ContactsContract.Intents.Insert.SECONDARY_PHONE, phones[1])
                }
            }

            // Add email
            val email = contactData["email"] as? String
            if (!email.isNullOrEmpty()) {
                putExtra(ContactsContract.Intents.Insert.EMAIL, email)
            }

            // Add website in notes
            val website = contactData["website"] as? String
            if (!website.isNullOrEmpty()) {
                putExtra(ContactsContract.Intents.Insert.NOTES, "Website: $website")
            }
        }

        startActivity(intent)
    }
}
