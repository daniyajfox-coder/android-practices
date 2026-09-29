package com.example.library.tasks.task15;

import android.os.Bundle;
import android.text.InputType;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.util.Locale;

/** Таймер скидки магазина */
public class Task15Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task15_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task15_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;

        final EditText p = Ui.edit(this, "Исходная цена (руб.)", DEC);
        final EditText pc = Ui.edit(this, "Скидка (%)", DEC);
        Button btn = Ui.button(this, "Рассчитать");
        final TextView res = Ui.text(this, "", 20);
        btn.setOnClickListener(v -> {
            try {
                double price = Ui.num(p), percent = Ui.num(pc);
                if (price < 0 || percent < 0 || percent > 100) {
                    Ui.toast(this, "Цена ≥ 0, скидка от 0 до 100%"); return;
                }
                double discount = price * percent / 100;
                res.setText(String.format(Locale.getDefault(),
                        "Скидка: %.2f руб.\nИтого: %.2f руб.", discount, price - discount));
            } catch (NumberFormatException e) { Ui.toast(this, "Заполните оба поля числами!"); }
        });
        Ui.add(c, p, pc, btn, res);
    }
}
