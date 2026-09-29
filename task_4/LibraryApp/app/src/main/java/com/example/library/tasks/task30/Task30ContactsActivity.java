package com.example.library.tasks.task30;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Задание №30: раздел портфолио «Контакты». */
public class Task30ContactsActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText("Контакты");
        LinearLayout c = findViewById(R.id.layoutContainer);
        ((Button) findViewById(R.id.btnBack)).setOnClickListener(v -> finish());
        final String phone = "+79001234567";
        final String email = "student@example.com";
        c.addView(Ui.text(this, "Телефон: " + phone, 18));
        c.addView(Ui.text(this, "Почта: " + email, 18));
        Button call = Ui.button(this, "Позвонить");
        call.setOnClickListener(v -> {
            try { startActivity(new Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + phone))); }
            catch (ActivityNotFoundException e) { Ui.toast(this, "Нет приложения для звонков"); }
        });
        Button mail = Ui.button(this, "Написать письмо");
        mail.setOnClickListener(v -> {
            try { startActivity(new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:" + email))); }
            catch (ActivityNotFoundException e) { Ui.toast(this, "Нет почтового приложения"); }
        });
        c.addView(call);
        c.addView(mail);
    }
}
