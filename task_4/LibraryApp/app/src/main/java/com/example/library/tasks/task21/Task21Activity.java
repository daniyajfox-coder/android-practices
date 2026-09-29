package com.example.library.tasks.task21;

import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Экран входа и Личный кабинет: ввод данных */
public class Task21Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task21_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task21_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int TXT = InputType.TYPE_CLASS_TEXT;
        Button btnNext = findViewById(R.id.btnNext);

        final EditText login = Ui.edit(this, "Логин", TXT);
        final EditText pass = Ui.edit(this, "Пароль", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        Ui.add(c, login, pass);
        btnNext.setText("Войти");
        btnNext.setOnClickListener(v -> {
            String l = Ui.str(login), p = pass.getText().toString();
            if (l.equals("admin") && p.equals("1234")) {
                Intent intent = new Intent(Task21Activity.this, Task21Step2Activity.class);
                intent.putExtra("KEY_LOGIN", l);
                startActivity(intent);
            } else {
                Ui.toast(this, "Неверный логин или пароль");
            }
        });
    }
}
