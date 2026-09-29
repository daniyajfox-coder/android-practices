package com.example.library.tasks.task08;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Симулятор фонарика */
public class Task08Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task08_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task08_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final View root = findViewById(android.R.id.content);
        root.setBackgroundColor(Color.BLACK);
        final boolean[] white = {false};
        final Button btn = Ui.button(this, "Включить фонарик");
        btn.setOnClickListener(v -> {
            white[0] = !white[0];
            root.setBackgroundColor(white[0] ? Color.WHITE : Color.BLACK);
            btn.setText(white[0] ? "Выключить фонарик" : "Включить фонарик");
            android.view.WindowManager.LayoutParams lp = getWindow().getAttributes();
            lp.screenBrightness = white[0] ? 1.0f : android.view.WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE;
            getWindow().setAttributes(lp);
        });
        Ui.add(c, btn);
    }
}
