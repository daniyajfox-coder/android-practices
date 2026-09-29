package com.example.library.tasks.task24;

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

/** Конструктор визитки мастера: результат */
public class Task24Step2Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task24_title_result);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());

        String name = getIntent().getStringExtra("KEY_NAME");
        String prof = getIntent().getStringExtra("KEY_PROF");
        final String phone = getIntent().getStringExtra("KEY_PHONE");
        c.addView(Ui.text(this, "ВИЗИТКА МАСТЕРА", 14));
        c.addView(Ui.text(this, name, 24));
        c.addView(Ui.text(this, prof, 18));
        c.addView(Ui.text(this, "Тел.: " + phone, 18));
        Button btnCall = Ui.button(this, "Позвонить");
        btnCall.setOnClickListener(v -> {
            Intent dial = new Intent(Intent.ACTION_DIAL);
            dial.setData(Uri.parse("tel:" + Uri.encode(phone)));
            try { startActivity(dial); }
            catch (ActivityNotFoundException e) { Ui.toast(this, "Нет приложения для звонков"); }
        });
        c.addView(btnCall);
    }
}
