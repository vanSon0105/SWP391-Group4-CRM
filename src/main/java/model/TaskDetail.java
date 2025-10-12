package model;
import java.util.*;
import java.sql.Timestamp;

public class TaskDetail {
	private int id;
	private int taskId;
	private int technicalStaffId;
	private Timestamp assignAt;
	private Timestamp deadline;
	private String status;
	public TaskDetail() {
		super();
	}
	public TaskDetail(int id, int taskId, int technicalStaffId, Timestamp assignAt, Timestamp deadline, String status) {
		super();
		this.id = id;
		this.taskId = taskId;
		this.technicalStaffId = technicalStaffId;
		this.assignAt = assignAt;
		this.deadline = deadline;
		this.status = status;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getTaskId() {
		return taskId;
	}
	public void setTaskId(int taskId) {
		this.taskId = taskId;
	}
	public int getTechnicalStaffId() {
		return technicalStaffId;
	}
	public void setTechnicalStaffId(int technicalStaffId) {
		this.technicalStaffId = technicalStaffId;
	}
	public Timestamp getAssignAt() {
		return assignAt;
	}
	public void setAssignAt(Timestamp assignAt) {
		this.assignAt = assignAt;
	}
	public Timestamp getDeadline() {
		return deadline;
	}
	public void setDeadline(Timestamp deadline) {
		this.deadline = deadline;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "TaskDetail [id=" + id + ", taskId=" + taskId + ", technicalStaffId=" + technicalStaffId + ", assignAt="
				+ assignAt + ", deadline=" + deadline + ", status=" + status + "]";
	}
	
	
	
}
