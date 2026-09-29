package com.example.library.tasks.task26;

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

/** Калькулятор автокредита: ввод данных */
public class Task26Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task26_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task26_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;
        final int INT = InputType.TYPE_CLASS_NUMBER;
        Button btnNext = findViewById(R.id.btnNext);

        final EditText amount = Ui.edit(this, "Сумма кредита (руб.)", DEC);
        final EditText rate = Ui.edit(this, "Годовая ставка (%)", DEC);
        final EditText months = Ui.edit(this, "Срок (месяцев, до 120)", INT);
        Ui.add(c, amount, rate, months);
        btnNext.setText("Рассчитать");
        btnNext.setOnClickListener(v -> {
            double sum, r; int m;
            try {
                sum = Ui.num(amount); r = Ui.num(rate);
                m = Integer.parseInt(Ui.str(months));
            } catch (NumberFormatException e) { Ui.toast(this, "Заполните все поля числами!"); return; }
            if (sum <= 0 || r < 0 || m < 1 || m > 120) {
                Ui.toast(this, "Сумма > 0, ставка ≥ 0, срок 1–120 мес."); return;
            }
            Intent intent = new Intent(Task26Activity.this, Task26Step2Activity.class);
            intent.putExtra("KEY_AMOUNT", sum);
            intent.putExtra("KEY_RATE", r);
            intent.putExtra("KEY_MONTHS", m);
            startActivity(intent);
        });
    }
}
