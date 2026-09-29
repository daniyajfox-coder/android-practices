package com.example.library.tasks.task30;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Задание №30: раздел портфолио «Обо мне». */
public class Task30AboutActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText("Обо мне");
        LinearLayout c = findViewById(R.id.layoutContainer);
        ((Button) findViewById(R.id.btnBack)).setOnClickListener(v -> finish());
        c.addView(Ui.text(this, "Ануфриев Д.", 22));
        c.addView(Ui.text(this, "Студент, изучаю разработку мобильных приложений. "
                + "Пишу Android-приложения на Java: от простых калькуляторов до многоэкранных проектов. "
                + "Интересуюсь C++ и работой с базами данных на SQL. "
                + "Люблю разбираться, как всё устроено, и доводить проекты до рабочего результата.", 18));
    }
}
