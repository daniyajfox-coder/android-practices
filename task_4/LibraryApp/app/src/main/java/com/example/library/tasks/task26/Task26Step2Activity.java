package com.example.library.tasks.task26;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.util.Locale;

/** Калькулятор автокредита: результат */
public class Task26Step2Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task26_title_result);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());

        double sum = getIntent().getDoubleExtra("KEY_AMOUNT", 0);
        double rate = getIntent().getDoubleExtra("KEY_RATE", 0);
        int months = getIntent().getIntExtra("KEY_MONTHS", 1);
        double mr = rate / 12 / 100; // месячная ставка
        // аннуитетный платёж (при нулевой ставке — простое деление)
        double payment = mr == 0 ? sum / months
                : sum * mr / (1 - Math.pow(1 + mr, -months));
        c.addView(Ui.text(this, String.format(Locale.getDefault(),
                "Ежемесячный платёж: %.2f руб.\nОбщая сумма выплат: %.2f руб.\nПереплата: %.2f руб.",
                payment, payment * months, payment * months - sum), 18));
        c.addView(Ui.text(this, "График выплат:", 18));
        double balance = sum;
        for (int i = 1; i <= months; i++) {
            double interest = balance * mr;
            double principal = payment - interest;
            balance = Math.max(0, balance - principal);
            if (i == months) balance = 0;
            c.addView(Ui.text(this, String.format(Locale.getDefault(),
                    "Месяц %d: платёж %.2f, остаток %.2f руб.", i, payment, balance), 14));
        }
    }
}
