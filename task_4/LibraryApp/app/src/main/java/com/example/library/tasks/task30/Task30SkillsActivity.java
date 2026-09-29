package com.example.library.tasks.task30;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Задание №30: раздел портфолио «Мои навыки». */
public class Task30SkillsActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText("Мои навыки");
        LinearLayout c = findViewById(R.id.layoutContainer);
        ((Button) findViewById(R.id.btnBack)).setOnClickListener(v -> finish());
        String[] skills = {"Java", "C++ (основы, интересуюсь глубже)", "SQL (запросы, работа с БД)",
                "Android SDK (Activity, Intent, Layout)", "XML-вёрстка интерфейсов",
                "Android Studio, Gradle", "Основы Git"};
        for (String s : skills) c.addView(Ui.text(this, "• " + s, 18));
    }
}
