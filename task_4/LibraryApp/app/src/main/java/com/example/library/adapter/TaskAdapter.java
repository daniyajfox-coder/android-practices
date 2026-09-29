package com.example.library.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.library.R;
import com.example.library.model.Task;

import java.util.List;

/**
 * Адаптер карточек-заданий. Раскрашивает бейдж уровня и открывает
 * соответствующую Activity по клику.
 */
public class TaskAdapter extends RecyclerView.Adapter<TaskAdapter.TaskViewHolder> {

    private final Context context;
    private List<Task> tasks;

    public TaskAdapter(Context context, List<Task> tasks) {
        this.context = context;
        this.tasks = tasks;
    }

    public void updateData(List<Task> newTasks) {
        this.tasks = newTasks;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public TaskViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_task, parent, false);
        return new TaskViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull TaskViewHolder holder, int position) {
        Task task = tasks.get(position);

        holder.tvNumber.setText(String.valueOf(task.getNumber()));
        holder.tvTitle.setText(task.getTitle());
        holder.tvLevel.setText(levelLabel(task.getLevel()));
        holder.tvLevel.setBackgroundColor(levelColor(task.getLevel()));

        holder.itemView.setOnClickListener(v -> {
            Intent intent = new Intent(context, task.getActivityClass());
            context.startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return tasks.size();
    }

    private String levelLabel(int level) {
        switch (level) {
            case 1: return "Уровень 1";
            case 2: return "Уровень 2";
            default: return "Уровень 3";
        }
    }

    private int levelColor(int level) {
        switch (level) {
            case 1: return Color.parseColor("#43A047"); // зелёный
            case 2: return Color.parseColor("#1E88E5"); // синий
            default: return Color.parseColor("#8E24AA"); // фиолетовый
        }
    }

    static class TaskViewHolder extends RecyclerView.ViewHolder {
        TextView tvNumber;
        TextView tvTitle;
        TextView tvLevel;

        TaskViewHolder(View itemView) {
            super(itemView);
            tvNumber = itemView.findViewById(R.id.tvNumber);
            tvTitle = itemView.findViewById(R.id.tvTitle);
            tvLevel = itemView.findViewById(R.id.tvLevel);
        }
    }
}
