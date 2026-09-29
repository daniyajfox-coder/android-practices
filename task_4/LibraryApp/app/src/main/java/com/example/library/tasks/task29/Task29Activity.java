package com.example.library.tasks.task29;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;

/** Мини-словарь: выбор термина, номер уходит на экран описания */
public class Task29Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task29_main);

        Button btn1 = findViewById(R.id.btnTerm1);
        Button btn2 = findViewById(R.id.btnTerm2);
        Button btn3 = findViewById(R.id.btnTerm3);

        btn1.setOnClickListener(v -> openTerm(1));
        btn2.setOnClickListener(v -> openTerm(2));
        btn3.setOnClickListener(v -> openTerm(3));
    }

    private void openTerm(int termIndex) {
        Intent intent = new Intent(this, Task29DetailActivity.class);
        intent.putExtra("KEY_TERM_INDEX", termIndex);
        startActivity(intent);
    }
}
