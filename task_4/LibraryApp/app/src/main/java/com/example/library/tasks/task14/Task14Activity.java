package com.example.library.tasks.task14;

import android.graphics.Color;
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

/** Простой калькулятор (4 действия) */
public class Task14Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task14_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task14_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;
        final int DECS = DEC | InputType.TYPE_NUMBER_FLAG_SIGNED;

        final EditText a = Ui.edit(this, "Число A", DECS);
        final EditText b = Ui.edit(this, "Число B", DECS);
        Button plus = Ui.button(this, "+");
        Button minus = Ui.button(this, "-");
        Button mul = Ui.button(this, "*");
        Button div = Ui.button(this, "/");
        final TextView res = Ui.text(this, "", 22);
        View.OnClickListener l = v -> {
            double x, y;
            try { x = Ui.num(a); y = Ui.num(b); }
            catch (NumberFormatException e) { Ui.toast(this, "Введите оба числа!"); return; }
            double r;
            if (v == plus) r = x + y;
            else if (v == minus) r = x - y;
            else if (v == mul) r = x * y;
            else {
                if (y == 0) { Ui.err(res, "Ошибка: деление на ноль!"); return; }
                r = x / y;
            }
            res.setTextColor(Color.BLACK);
            res.setText("Результат: " + (r == Math.rint(r) && Math.abs(r) < 1e15
                    ? String.valueOf((long) r) : String.format(Locale.getDefault(), "%.4f", r)));
        };
        plus.setOnClickListener(l); minus.setOnClickListener(l);
        mul.setOnClickListener(l); div.setOnClickListener(l);
        Ui.add(c, a, b, plus, minus, mul, div, res);
    }
}
