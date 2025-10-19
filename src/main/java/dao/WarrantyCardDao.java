package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dal.DBContext;
import model.WarrantyCard;

public class WarrantyCardDao extends DBContext{
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();

}
