package com.example.library.tasks.task22;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Оформление заказа пиццы: результат */
public class Task22Step2Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task22_title_result);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());

        String size = getIntent().getStringExtra("KEY_SIZE");
        String addr = getIntent().getStringExtra("KEY_ADDRESS");
        int price = getIntent().getIntExtra("KEY_PRICE", 0);
        c.addView(Ui.text(this, "ЧЕК", 20));
        c.addView(Ui.text(this, "Размер: " + size, 18));
        c.addView(Ui.text(this, "Адрес: " + addr, 18));
        c.addView(Ui.text(this, "Итого: " + price + " ₽", 22));
        btnBack.setText("Назад к заказу");
    }
}
