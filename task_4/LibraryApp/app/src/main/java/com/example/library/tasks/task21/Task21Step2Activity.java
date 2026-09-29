package com.example.library.tasks.task21;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Экран входа и Личный кабинет: результат */
public class Task21Step2Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task21_title_result);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());

        String user = getIntent().getStringExtra("KEY_LOGIN");
        if (user == null) user = "Гость";
        c.addView(Ui.text(this, "Добро пожаловать, " + user + "!", 22));
        c.addView(Ui.text(this, "Это ваш личный кабинет.", 16));
        btnBack.setText("Выйти");
    }
}
