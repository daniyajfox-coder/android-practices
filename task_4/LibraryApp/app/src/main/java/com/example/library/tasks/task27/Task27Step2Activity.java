package com.example.library.tasks.task27;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/** Электронный билет на поезд: результат */
public class Task27Step2Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task27_title_result);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());

        String from = getIntent().getStringExtra("KEY_FROM");
        String to = getIntent().getStringExtra("KEY_TO");
        String date = new SimpleDateFormat("dd.MM.yyyy", Locale.getDefault()).format(new Date());
        c.addView(Ui.text(this, "ПОСАДОЧНЫЙ ТАЛОН", 14));
        c.addView(Ui.text(this, "Билет: " + from + " → " + to, 22));
        c.addView(Ui.text(this, "Дата: " + date, 18));
    }
}
