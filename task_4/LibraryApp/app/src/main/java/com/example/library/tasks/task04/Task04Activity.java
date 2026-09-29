package com.example.library.tasks.task04;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Переключатель видимости */
public class Task04Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task04_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task04_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final TextView secret = Ui.text(this, "Секрет: Android — это весело!", 20);
        secret.setVisibility(View.GONE);
        final Button btn = Ui.button(this, "Показать секрет");
        btn.setOnClickListener(v -> {
            if (secret.getVisibility() == View.GONE) {
                secret.setVisibility(View.VISIBLE);
                btn.setText("Скрыть секрет");
            } else {
                secret.setVisibility(View.GONE);
                btn.setText("Показать секрет");
            }
        });
        Ui.add(c, btn, secret);
    }
}
