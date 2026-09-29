package com.example.library.tasks.task22;

import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Оформление заказа пиццы: ввод данных */
public class Task22Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task22_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task22_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int TXT = InputType.TYPE_CLASS_TEXT;
        Button btnNext = findViewById(R.id.btnNext);

        final String[] names = {"S (25 см)", "M (30 см)", "L (35 см)"};
        final int[] prices = {300, 450, 600};
        Ui.add(c, Ui.text(this, "Размер пиццы:", 16));
        final RadioGroup rg = new RadioGroup(this);
        for (int i = 0; i < names.length; i++) {
            RadioButton rb = new RadioButton(this);
            rb.setId(View.generateViewId());
            rb.setText(names[i] + " — " + prices[i] + " ₽");
            rg.addView(rb);
        }
        final EditText addr = Ui.edit(this, "Адрес доставки", TXT);
        Ui.add(c, rg, addr);
        btnNext.setText("Оформить заказ");
        btnNext.setOnClickListener(v -> {
            int idx = rg.indexOfChild(findViewById(rg.getCheckedRadioButtonId()));
            String a = Ui.str(addr);
            if (idx < 0) { Ui.toast(this, "Выберите размер пиццы!"); return; }
            if (a.isEmpty()) { Ui.toast(this, "Введите адрес доставки!"); return; }
            Intent intent = new Intent(Task22Activity.this, Task22Step2Activity.class);
            intent.putExtra("KEY_SIZE", names[idx]);
            intent.putExtra("KEY_ADDRESS", a);
            intent.putExtra("KEY_PRICE", prices[idx]);
            startActivity(intent);
        });
    }
}
