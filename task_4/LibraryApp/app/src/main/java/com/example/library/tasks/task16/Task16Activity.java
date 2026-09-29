package com.example.library.tasks.task16;

import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.util.Locale;

/** Конвертер валют */
public class Task16Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task16_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task16_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;

        final double USD_RATE = 95.0, EUR_RATE = 105.0;
        Ui.add(c, Ui.text(this, "Условный курс: 1 $ = 95 руб., 1 € = 105 руб.", 14));
        final EditText et = Ui.edit(this, "Сумма в рублях", DEC);
        Button usd = Ui.button(this, "В доллары");
        Button eur = Ui.button(this, "В евро");
        final TextView res = Ui.text(this, "", 20);
        View.OnClickListener l = v -> {
            try {
                double rub = Ui.num(et);
                if (rub < 0) { Ui.toast(this, "Сумма не может быть отрицательной"); return; }
                boolean isUsd = v == usd;
                res.setText(String.format(Locale.getDefault(), "%.2f руб. = %.2f %s",
                        rub, rub / (isUsd ? USD_RATE : EUR_RATE), isUsd ? "$" : "€"));
            } catch (NumberFormatException e) { Ui.toast(this, "Введите сумму!"); }
        };
        usd.setOnClickListener(l); eur.setOnClickListener(l);
        Ui.add(c, et, usd, eur, res);
    }
}
