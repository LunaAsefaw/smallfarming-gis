--create database farming;
		-- add connect statement here

		

create extension postgis;

----------------------------------------INFRASTRUCTURE-------------------------------------
-- INFRASTRUCTURE TYPE
CREATE TABLE infrastructure_type (
    	id SERIAL NOT NULL PRIMARY KEY, 
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT

); 
COMMENT ON TABLE infrastructure_type IS 'Lookup table for the types of infrastructure available, e.g. Furniture .';
COMMENT ON COLUMN infrastructure_type.id is 'The unique infrastructure type ID. This is the Primary Key.';
COMMENT ON COLUMN infrastructure_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_type.name is 'The infrastructure type name.';
COMMENT ON COLUMN infrastructure_type.notes is 'Additional information of the infrastructure type.';
COMMENT ON COLUMN infrastructure_type.image is 'Image of the infrastructure type.';


-- INFRASTRUCTURE ITEM
CREATE TABLE infrastructure_item(
    	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT NOT NULL, 
	notes TEXT, 
	image TEXT,
    	geometry GEOMETRY (POINT, 4326), 
    	infrastructure_type_uuid UUID NOT NULL REFERENCES infrastructure_type(uuid)
);
COMMENT ON TABLE infrastructure_item IS 'Infrastructure item refers to any physical components found in the area, e.g. desk, chair.';
COMMENT ON COLUMN infrastructure_item.id is 'The unique infrastructure item ID. Primary Key.';
COMMENT ON COLUMN infrastructure_item.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_item.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_item.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_item.name is 'The name of the infrastructure item.';
COMMENT ON COLUMN infrastructure_item.notes is 'Additional information of the infrastructure item.';
COMMENT ON COLUMN infrastructure_item.image is 'Image of the infrastructure item.';
COMMENT ON COLUMN infrastructure_item.geometry is 'The centroid location of the infrastructure item. Follows EPSG: 4326.';


-- INFRASTRUCTURE LOG ACTION
CREATE TABLE infrastructure_log_action(
    	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT
);
COMMENT ON TABLE infrastructure_log_action IS 'Infrastructure log action refers to the actions taken to maintain infrastructure items, e.g. Screwing, Painting, Welding.';
COMMENT ON COLUMN infrastructure_log_action.id is 'The unique log action ID. Primary Key.';
COMMENT ON COLUMN infrastructure_log_action.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_log_action.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_log_action.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_log_action.name is 'The name of the action taken.';
COMMENT ON COLUMN infrastructure_log_action.notes is 'Additional information of the action taken.';
COMMENT ON COLUMN infrastructure_log_action.image is 'Image of the action taken.';


-- INFRASTRUCTURE MANAGEMENT LOG 
CREATE TABLE infrastructure_management_log(
    	id SERIAL NOT NULL PRIMARY KEY, 
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
    	condition TEXT NOT NULL, 
    	infrastructure_item_uuid UUID NOT NULL REFERENCES infrastructure_item(uuid),
    	infrastructure_log_action_uuid UUID NOT NULL REFERENCES infrastructure_log_action (uuid)
);
COMMENT ON TABLE infrastructure_management_log IS 'Infrastructure management log refers to the process of task that needs to be done on an infrastructure item, e.g. Repair.';
COMMENT ON COLUMN infrastructure_management_log.id is 'The unique management log ID. Primary Key.';
COMMENT ON COLUMN infrastructure_management_log.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_management_log.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_management_log.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_management_log.name is 'The name of the process.';
COMMENT ON COLUMN infrastructure_management_log.notes is 'Additional information of the process.';
COMMENT ON COLUMN infrastructure_management_log.image is 'Image of the work flow.';
COMMENT ON COLUMN infrastructure_management_log.condition is 'Circumstances or factors affecting the infrastructure item type.';


----------------------------------------ELECTRICITY-------------------------------------
-- ELECTRICITY LINE TYPE
CREATE TABLE electricity_line_type (
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
        sort_order INT UNIQUE,
	-- Add unique together constraint for voltage and current
	current_a FLOAT NOT NULL,
	voltage_v FLOAT NOT NULL,
	-- Unique together constraint for voltage and current
	UNIQUE(current_a, voltage_v)
);
COMMENT ON TABLE electricity_line_type IS 'Look up table for the types of electricity lines, e.g. Low-voltage line, High-voltage line etc.';
COMMENT ON COLUMN electricity_line_type.id is 'The unique electricity line type ID. Primary key.';
COMMENT ON COLUMN electricity_line_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line_type.name is 'The name of the electricity line type.';
COMMENT ON COLUMN electricity_line_type.notes is 'Additional information of the electricity line type.';
COMMENT ON COLUMN electricity_line_type.image is 'Image of the electricity line type';
COMMENT ON COLUMN electricity_line_type.sort_order is 'Defines the pattern of how electricity line type records are to be sorted.';
COMMENT ON COLUMN electricity_line_type.current_a is 'The electricity line current measured in ampere.';
COMMENT ON COLUMN electricity_line_type.voltage_v is 'The electricity line voltage measured in volt.';


-- ELECTRICITY LINE
CREATE TABLE electricity_line (
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
	notes TEXT, 
	image TEXT,
	geometry GEOMETRY(LINESTRING, 4326) NOT NULL,
	electricity_line_type_uuid UUID NOT NULL REFERENCES electricity_line_type(uuid)
);
COMMENT ON TABLE electricity_line IS 'Electricity line refers to the geolocated wire or conductor used for transmitting or supplying electricity.';
COMMENT ON COLUMN electricity_line.id is 'The unique electricity line ID. Primary key.';
COMMENT ON COLUMN electricity_line.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line.notes is 'Additional information of the electricity line.';
COMMENT ON COLUMN electricity_line.image is 'Image of the electricity line';
COMMENT ON COLUMN electricity_line.geometry is 'The location of the electricity line. Follows EPSG: 4326.';


-- ELECTRICITY LINE CONDITION
CREATE TABLE electricity_line_condition_type (
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE electricity_line_condition_type IS 'Look up table for the types of electricity line conditions, e.g. Working, Broken etc.';
COMMENT ON COLUMN electricity_line_condition_type.id is 'The unique electricity line condition ID. Primary key.';
COMMENT ON COLUMN electricity_line_condition_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line_condition_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line_condition_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line_condition_type.name is 'The name of the electricity line condition.';
COMMENT ON COLUMN electricity_line_condition_type.notes is 'Additional information of the electricity line condition.';
COMMENT ON COLUMN electricity_line_condition_type.image is 'Image of the electricity line condition.';
COMMENT ON COLUMN electricity_line_condition_type.sort_order is 'Defines the pattern of how  electricity line condition records are to be sorted.';


-- ASSOCIATION TABLES
-- ELECTRICITY LINE CONDITION
CREATE TABLE electricity_line_conditions (
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL, 
	notes TEXT, 
	image TEXT,
	date DATE NOT NULL,
	electricity_line_uuid UUID NOT NULL REFERENCES electricity_line(uuid),
	electricity_line_condition_uuid UUID NOT NULL REFERENCES electricity_line_condition_type(uuid),
	-- Composite primary key
	PRIMARY KEY (electricity_line_uuid, electricity_line_condition_uuid, date),
	-- Unique together
	UNIQUE(electricity_line_uuid, electricity_line_condition_uuid, date)
);
COMMENT ON TABLE electricity_line_conditions IS 'Associative table which stores the electricity line and its condition on a particular day.';
COMMENT ON COLUMN electricity_line_conditions.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line_conditions.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line_conditions.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line_conditions.notes is 'Additional information of the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.image is 'Image of the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.date is 'The electricity line inspection date.';      


----------------------------------------WATER-------------------------------------
-- WATER SOURCE
CREATE TABLE water_source(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT
);
COMMENT ON TABLE water_source IS 'Water source refers to the geolocated water bodies that provide drinking water, e.g. Aquifer.';
COMMENT ON COLUMN water_source.id is 'The unique water source ID. This is the Primary Key.';
COMMENT ON COLUMN water_source.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_source.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_source.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_source.name is 'The name of the water source.';
COMMENT ON COLUMN water_source.notes is 'Additional information of the water body.';
COMMENT ON COLUMN water_source.image is 'Image of the water body.';


-- WATER POLYGON TYPE
CREATE TABLE water_polygon_type(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT
);
COMMENT ON TABLE water_polygon_type IS 'Lookup table of the type of water polygon, e.g. Lake.';
COMMENT ON COLUMN water_polygon_type.id is 'The unique water polygon ID. Primary Key.';
COMMENT ON COLUMN water_polygon_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_polygon_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_polygon_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_polygon_type.name is 'The name of the water polygon type.';
COMMENT ON COLUMN water_polygon_type.notes is 'Additional information of the water polygon type.';
COMMENT ON COLUMN water_polygon_type.image is 'Image of the water polygon type.';


-- WATER POLYGON
CREATE TABLE water_polygon(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
	estimated_depth_m FLOAT,
	-- Estimated depth of water polygon constraint (0m < Estimated Depth < 20m).
	CONSTRAINT depth_check check(
	estimated_depth_m >= 0 and estimated_depth_m <= 20),
	geometry GEOMETRY(POLYGON, 4326),
	water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
	water_polygon_type_uuid UUID NOT NULL REFERENCES water_polygon_type(uuid)
);
COMMENT ON TABLE water_polygon IS 'Water polygon refers to the geolocated land areas that are covered in water, either intermittently or constantly, e.g. River.';
COMMENT ON COLUMN water_polygon.id is 'The unique water polygon ID. Primary Key.';
COMMENT ON COLUMN water_polygon.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_polygon.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_polygon.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_polygon.name is 'The name of the water polygon.';
COMMENT ON COLUMN water_polygon.notes is 'Additional information of the water polygon.';
COMMENT ON COLUMN water_polygon.image is 'Image of the water polygon.';
COMMENT ON COLUMN water_polygon.estimated_depth_m is 'The approximate depth of the water polygon measured in meters.';
COMMENT ON COLUMN water_polygon.geometry is 'The location of the water polygon. Follows EPSG: 4326.';


-- WATER POINT TYPE
CREATE TABLE water_point_type (
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT
);
COMMENT ON TABLE water_point_type is 'Lookup table on the types of water points, e.g. Drinking trough.';
COMMENT ON COLUMN water_point_type.id is 'The unique water point type ID. Primary Key.';
COMMENT ON COLUMN water_point_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_point_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_point_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_point_type.name is 'The name of the water point type.';
COMMENT ON COLUMN water_point_type.notes is 'Additional information of the water point type.';
COMMENT ON COLUMN water_point_type.image is 'Image of the water point type.';

-- WATER POINT 
CREATE TABLE water_point(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
	notes TEXT, 
	image TEXT,
	geometry GEOMETRY (POINT, 4326),
	water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
	water_point_type_uuid UUID NOT NULL REFERENCES water_point_type(uuid)
);
COMMENT ON TABLE water_point is 'Water point refers to the geolocated water site that is available for use, e.g. Tap.';
COMMENT ON COLUMN water_point.id is 'The unique water point ID. Primary Key.';
COMMENT ON COLUMN water_point.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_point.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_point.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_point.notes is 'Additional information of the water point.';
COMMENT ON COLUMN water_point.image is 'Image of the water point.';
COMMENT ON COLUMN water_point.geometry is 'The coordinates of the water point. Follows EPSG: 4326.';


-- WATER LINE TYPE
CREATE TABLE water_line_type (
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
        sort_order INT UNIQUE,
	pipe_length_m FLOAT,
	pipe_diameter_m FLOAT,
	-- Pipe length & pipe diameter constraint (length, diameter > 0)
	CONSTRAINT pipe_length_and_diameter_check check(
	pipe_length_m >= 0 AND pipe_diameter_m >= 0),
	-- Unique together
	UNIQUE(pipe_length_m, pipe_diameter_m)
);
COMMENT ON TABLE water_line_type IS 'Description of the type of line through which water flows, e.g. Water pipe.';
COMMENT ON COLUMN water_line_type.id is 'The unique water line type ID. Primary Key.';
COMMENT ON COLUMN water_line_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_line_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_line_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_line_type.name is 'The name of the water line type.';
COMMENT ON COLUMN water_line_type.notes is 'Additional information of the water line type.';
COMMENT ON COLUMN water_line_type.image is 'Image of the water line type.';
COMMENT ON COLUMN water_line_type.sort_order is 'Defines the pattern of how water line types are to be sorted.';
COMMENT ON COLUMN water_line_type.pipe_length_m is 'The water line length measured in meters.';
COMMENT ON COLUMN water_line_type.pipe_diameter_m is 'The water line diameter measured in meters.';


-- WATER LINE
CREATE TABLE water_line(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
	notes TEXT, 
	image TEXT,
	estimated_depth_m FLOAT,
	--Estimated depth of water line (depth > 0)
	CONSTRAINT estimated_depth_m check(
	estimated_depth_m >= 0),
	geometry GEOMETRY(LINESTRING, 4326),
	water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
	water_line_type_uuid UUID NOT NULL REFERENCES water_line_type(uuid)
);
COMMENT ON TABLE water_line is 'This is the geolocated path the water lines follow.';
COMMENT ON COLUMN water_line.id is 'The unique water line ID. Primary Key.';
COMMENT ON COLUMN water_line.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_line.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_line.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_line.notes is 'Additional information of the water line path.';
COMMENT ON COLUMN water_line.image is 'Image of the water line path.';
COMMENT ON COLUMN water_line.estimated_depth_m is 'The approximate depth of the water line measured in meters.';
COMMENT ON COLUMN water_line.geometry is 'The location of the water line. Follows EPSG: 4326';


----------------------------------------VEGETATION-------------------------------------
-- PLANT GROWTH ACTIVITY TYPE
CREATE TABLE plant_growth_activity_type (
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE plant_growth_activity_type IS 'Plant growth activity type refers to the different growth stages of plants, e.g. Sprouting, Seeding etc.';
COMMENT ON COLUMN plant_growth_activity_type.id IS 'The unique plant growth activity ID. This is the Primary Key.';
COMMENT ON COLUMN plant_growth_activity_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN plant_growth_activity_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN plant_growth_activity_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN plant_growth_activity_type.name is 'The name of the plant growth activity type.';
COMMENT ON COLUMN plant_growth_activity_type.notes is 'Additional information of the plant growth activity type.';
COMMENT ON COLUMN plant_growth_activity_type.image is 'Image of the plant growth activity type.';
COMMENT ON COLUMN plant_growth_activity_type.sort_order is 'Defines the pattern of how plant growth activity type records are to be sorted.';

-- PLANT TYPE
CREATE TABLE plant_type(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
	scientific_name TEXT UNIQUE,
	plant_image TEXT,
	flower_image TEXT,
	fruit_image TEXT,
	variety TEXT,
	info_url TEXT
);
COMMENT ON TABLE plant_type IS 'Look up table of different types of plants, e.g. Oaktree.';
COMMENT ON COLUMN plant_type.id IS 'The unique plant type ID. This is the Primary Key.';
COMMENT ON COLUMN plant_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN plant_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN plant_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN plant_type.name is 'The name of the plant type.';
COMMENT ON COLUMN plant_type.notes is 'Additional information of the plant type.';
COMMENT ON COLUMN plant_type.image is 'Image of the plant type.';
COMMENT ON COLUMN plant_type.scientific_name IS 'Scientific name of the plant type e.g. Quercus.';
COMMENT ON COLUMN plant_type.plant_image IS 'Path to image of plant.';
COMMENT ON COLUMN plant_type.flower_image IS 'Path to image of flower.';
COMMENT ON COLUMN plant_type.fruit_image IS 'Path to image of fruit.';
COMMENT ON COLUMN plant_type.variety IS 'Other variety of this plant type.';
COMMENT ON COLUMN plant_type.info_url IS 'URL link to more information about this specific plant type.';


-- MONTH
CREATE TABLE month(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE month IS 'Look up table for different months of the year, e.g. January, February etc.';
COMMENT ON COLUMN month.id IS 'The unique month ID. This is the Primary Key.';
COMMENT ON COLUMN month.uuid is 'The unique user ID.';
COMMENT ON COLUMN month.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN month.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN month.name is 'Name of the different months in the year e.g. January';
COMMENT ON COLUMN month.notes is 'Additional information of the month.';
COMMENT ON COLUMN month.image is 'Image of the object stored.';
COMMENT ON COLUMN month.sort_order is 'Defines the pattern of how month records are to be sorted.';


-- PLANT USAGE
CREATE TABLE plant_usage(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT
);
COMMENT ON TABLE plant_usage IS 'Look up table for different usages of the plants e.g. Food plant, Commercial plant etc.';
COMMENT ON COLUMN plant_usage.id IS 'The unique plant usage ID. This is the Primary Key.';
COMMENT ON COLUMN plant_usage.uuid is 'The unique user ID.';
COMMENT ON COLUMN plant_usage.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN plant_usage.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN plant_usage.name is 'The name of the plant usage.';
COMMENT ON COLUMN plant_usage.notes is 'Additional information of the plant usage.';
COMMENT ON COLUMN plant_usage.image is 'Image of the plant stored.';


-- VEGETATION POINT
CREATE TABLE vegetation_point(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
	notes TEXT, 
	image TEXT,
	estimated_crown_radius_m FLOAT,
	--Must be positive number
	constraint radius_check check(
	estimated_crown_radius_m >= 0),
	--Takes 4 digits only
	estimated_planting_year decimal(4,0),
	--Must be before or equal this year
	constraint year_check check(
	estimated_planting_year >= 0),
	constraint year_check2 check(
	estimated_planting_year <= DATE_PART('Year', NOW())),
	estimated_height_m FLOAT,
	--Must be positive number
	constraint height_check check(
	estimated_height_m >= 0),
	geometry GEOMETRY(POINT, 4326) NOT NULL, 
	plant_type_uuid UUID NOT NULL REFERENCES plant_type(uuid)
);
COMMENT ON TABLE vegetation_point IS 
'Vegetation point refers a geolocated plant. Table stores the individual plant location and the properties.';
COMMENT ON COLUMN vegetation_point.id IS 'The unique vegetation point ID. This is the Primary Key.';
COMMENT ON COLUMN vegetation_point.uuid is 'The unique user ID.';
COMMENT ON COLUMN vegetation_point.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN vegetation_point.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN vegetation_point.notes is 'Additional information of the vegetation point.';
COMMENT ON COLUMN vegetation_point.image is 'Image of the vegetation point.';
COMMENT ON COLUMN vegetation_point.estimated_crown_radius_m IS 'Estimated radius of the plant''s crown measured in meters.';
COMMENT ON COLUMN vegetation_point.estimated_height_m IS 'Estimated height of plant measured in meters.';
COMMENT ON COLUMN vegetation_point.estimated_planting_year IS 'The year the plant was planted. The year must be in the range of 0 to current year.';
COMMENT ON COLUMN vegetation_point.geometry IS 'The coordinates of the vegetation point. Follows EPSG 4326.';


-- PRUNING ACTIVITY
CREATE TABLE pruning_activity(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
	date DATE NOT NULL,
	before_image TEXT,
	after_image TEXT,
	vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
);
COMMENT ON TABLE pruning_activity IS 'Pruning activity refers to the trimming of unwanted parts of a plant.';
COMMENT ON COLUMN pruning_activity.id IS 'The unique pruning activity ID. This is the Primary Key.';
COMMENT ON COLUMN pruning_activity.uuid is 'The unique user ID.';
COMMENT ON COLUMN pruning_activity.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN pruning_activity.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN pruning_activity.name is 'The name of the pruning activity.';
COMMENT ON COLUMN pruning_activity.notes is 'Additional information of the  pruning activity.';
COMMENT ON COLUMN pruning_activity.image is 'Image of the  pruning activity.';
COMMENT ON COLUMN pruning_activity.date IS 'The date of the pruning activity (yyyy:mm:dd).';
COMMENT ON COLUMN pruning_activity.before_image IS 'Path to image before the pruning activity was done.';
COMMENT ON COLUMN pruning_activity.after_image IS 'Path to image after the pruning activity was done.';


-- HARVEST ACTIVITY
CREATE TABLE harvest_activity(
	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
	notes TEXT, 
	image TEXT,
	date DATE NOT NULL,
	quantity_kg FLOAT,
	vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
);
COMMENT ON TABLE harvest_activity IS 'Harvest activity refers to the gathering of ripe crop or fruits.';
COMMENT ON COLUMN harvest_activity.id IS 'The unique harvest activity ID. This is the Primary Key.';
COMMENT ON COLUMN harvest_activity.uuid is 'The unique user ID.';
COMMENT ON COLUMN harvest_activity.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN harvest_activity.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN harvest_activity.name is 'The name of the harvest activity.';
COMMENT ON COLUMN harvest_activity.notes is 'Additional information of the harvest activity.';
COMMENT ON COLUMN harvest_activity.image is 'Image of the harvest activity.';
COMMENT ON COLUMN harvest_activity.date IS 'The date of the harvest activity (yyyy:mm:dd).';
COMMENT ON COLUMN harvest_activity.quantity_kg IS 'The quantity of harvest measured in kilograms.';


-- ASSOCIATION TABLES
-- PLANT GROWTH ACTIVITIES
CREATE TABLE plant_growth_activities(
	fk_plant_activity_uuid UUID  NOT NULL REFERENCES plant_growth_activity_type(uuid),
	fk_plant_type_uuid UUID NOT NULL REFERENCES plant_type(uuid),
	fk_month_uuid UUID  NOT NULL REFERENCES month(uuid),
	-- Composite primary key using the three foreign keys above
	PRIMARY KEY (fk_plant_activity_uuid, fk_plant_type_uuid, fk_month_uuid)
);
COMMENT ON TABLE plant_growth_activities IS 
'Associative table to store the plant growth activities and plant types at different months in the year e.g. January_activity.';
COMMENT ON COLUMN plant_growth_activities.fk_plant_activity_uuid IS 'The foreign key linking to plant growth activity type table''s UUID.';
COMMENT ON COLUMN plant_growth_activities.fk_plant_type_uuid IS 'The foreign key linking to plant type table''s UUID.';
COMMENT ON COLUMN plant_growth_activities.fk_month_uuid IS 'The foreign key linking to month table''s UUID.';

-- PLANT TYPE USAGES
CREATE TABLE plant_type_usages(
	fk_plant_usage_uuid UUID NOT NULL REFERENCES plant_usage(uuid),
	fk_plant_type_uuid UUID NOT NULL REFERENCES plant_type(uuid),
	PRIMARY KEY (fk_plant_usage_uuid, fk_plant_type_uuid)
);
COMMENT ON TABLE plant_type_usages IS 
'Associative table to store the different plant usages and plant types ';
COMMENT ON COLUMN plant_type_usages.fk_plant_usage_uuid IS 'The foreign key linking to plant usage table''s UUID.';
COMMENT ON COLUMN plant_type_usages.fk_plant_type_uuid IS 'The foreign key linking to plant type table''s UUID.';



----------------------------------------MONITORING STATIONS-------------------------------------

-- READING UNIT
CREATE TABLE IF NOT EXISTS reading_unit (
   id SERIAL NOT NULL PRIMARY KEY,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   last_update TIMESTAMP DEFAULT now() NOT NULL,
   last_update_by TEXT NOT NULL,
   name TEXT NOT NULL,
   abbreviation TEXT NOT NULL
);

COMMENT ON TABLE reading_unit IS 'Look up table for monitoring station reading unit';
COMMENT ON COLUMN reading_unit.id IS 'The equipment type ID. This is the Primary Key.';
COMMENT ON COLUMN reading_unit.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN reading_unit.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN reading_unit.last_update_by IS 'The name of the person who updated the table last.';
COMMENT ON COLUMN reading_unit.name IS 'Where we make comments and a description about the reading_unit.';
COMMENT ON COLUMN reading_unit.abbreviation IS 'Where we make comments and a description about the reading_unit.';


-- EQUIPMENT TYPE
CREATE TABLE IF NOT EXISTS equipment_type (
   id SERIAL NOT NULL PRIMARY KEY,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   last_update TIMESTAMP DEFAULT now() NOT NULL,
   last_update_by TEXT NOT NULL,
   name TEXT NOT NULL,
   url TEXT,
   notes TEXT,
   model TEXT,
   manufacturer TEXT,
   calibration_date TIMESTAMP DEFAULT NOW() NOT NULL
);

COMMENT ON TABLE equipment_type IS 'Look up table for equipment type, e.g. moisture tester, penetrometers.';
COMMENT ON COLUMN equipment_type.id IS 'The equipment type ID. This is the Primary Key.';
COMMENT ON COLUMN equipment_type.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN equipment_type.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN equipment_type.last_update_by IS 'The name of the person who updated the table last.';
COMMENT ON COLUMN equipment_type.name IS 'Where we make comments and a description about the equipment type.';
COMMENT ON COLUMN equipment_type.url IS 'The URL is unique to the equipment type.';
COMMENT ON COLUMN equipment_type.notes IS 'Additional information of the equipment type';
COMMENT ON COLUMN equipment_type.model IS 'Where we make comments and a description about the equipment type.';
COMMENT ON COLUMN equipment_type.manufacturer IS 'Information about the manufacturer that manufactured the equipment.';
COMMENT ON COLUMN equipment_type.calibration_date IS 'The last date the equipment was calibrated.';


-- ASSOCIATION TABLE
-- MONITORING STATION
CREATE TABLE IF NOT EXISTS monitoring_station (
   id SERIAL NOT NULL PRIMARY KEY,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   last_update TIMESTAMP DEFAULT now() NOT NULL,
   last_update_by TEXT NOT NULL,
   name TEXT NOT NULL,
   image TEXT,
   equipment TEXT NOT NULL,
   geometry GEOMETRY (POINT, 4326) NOT NULL,
   equipment_type_uuid UUID NOT NULL REFERENCES equipment_type(uuid)
);

COMMENT ON TABLE monitoring_station IS 'Look up table for monitoring station, e.g. station 1, station 2.';
COMMENT ON COLUMN monitoring_station.id IS 'The monitoring station ID. This is the Primary Key.';
COMMENT ON COLUMN monitoring_station.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN monitoring_station.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN monitoring_station.last_update_by IS 'The name of the person who updated the table last.';
COMMENT ON COLUMN monitoring_station.name IS 'Where we make comments and a description about the equipment name.';
COMMENT ON COLUMN monitoring_station.image IS 'The image link associated with the monitoring station image.';
COMMENT ON COLUMN monitoring_station.geometry IS 'The location of the monitoring station. Follows EPSG: 4326.';
COMMENT ON COLUMN monitoring_station.equipment_type_uuid IS 'Globally Unique Identifier.';

-- ASSOCIATION TABLE
-- READINGS
CREATE TABLE IF NOT EXISTS readings (
   id SERIAL NOT NULL PRIMARY KEY,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   last_update TIMESTAMP DEFAULT now() NOT NULL,
   last_update_by TEXT NOT NULL,
   name TEXT NOT NULL,
   notes TEXT,
   equipment TEXT NOT NULL,
   geometry GEOMETRY (POINT, 4326) NOT NULL,
   soil_ph FLOAT NOT NULL,
   soil_temperature FLOAT NOT NULL,
   estimated_depth_m FLOAT NOT NULL,
   monitoring_station_uuid UUID NOT NULL REFERENCES monitoring_station(uuid),
   reading_unit_uuid UUID NOT NULL REFERENCES reading_unit(uuid)
);

COMMENT ON TABLE readings IS 'Look up table for readings, e.g. reading at station 1, station 2.';
COMMENT ON COLUMN readings.id IS 'The monitoring station ID. This is the Primary Key.';
COMMENT ON COLUMN readings.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN readings.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN readings.last_update_by IS 'The name of the person who updated the table last.';
COMMENT ON COLUMN readings.name IS 'Where we make comments and a description about the readings name.';
COMMENT ON COLUMN readings.notes IS 'Additional information of the readings.';
COMMENT ON COLUMN readings.equipment IS 'Equipment name used for the readings.  e.g. moisture_testers, penetrometers';
COMMENT ON COLUMN readings.geometry IS 'The location of the monitoring station. Follows EPSG: 4326.';
COMMENT ON COLUMN readings.soil_ph IS 'The soil ph measured in pH scale is from 0 (most acid) to 14 (most alkaline) and a pH of 7 is neutral.';
COMMENT ON COLUMN readings.soil_temperature IS 'The soil temperature measured in degrees celcius.';
COMMENT ON COLUMN readings.estimated_depth_m IS 'The estimated_depth length measured in meters.';

-----------------------------------------------------------------------------------------------------
-- CONDITIONS
CREATE TABLE IF NOT EXISTS condition (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT UNIQUE NOT NULL,
    notes TEXT,
    image TEXT
);
COMMENT ON TABLE condition  IS 'Look up table for condition, e.g. good, bad.';
COMMENT ON COLUMN condition.id IS 'The unique condition item id. Primary key.';
COMMENT ON COLUMN condition.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN condition.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN condition.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN condition.name IS 'The name of the condition item.';
COMMENT ON COLUMN condition.notes IS 'Additional information of the condition item.';
COMMENT ON COLUMN condition.image IS 'Image of the condition item.';

---------------------------------------- LAND USE BUILDINGS -------------------------------------

-- BUILDING TYPE --
CREATE TABLE IF NOT EXISTS building_type(
   id serial PRIMARY KEY, -- We said this should be serial, not int. Also 'id', not 'building_type_id'
   name VARCHAR UNIQUE NOT NULL, --this was named 'name' in the erd, not 'type_name'. Must be unique
   notes TEXT,
   image TEXT,
   last_update TIMESTAMP DEFAULT now()NOT NULL,
   last_update_by TEXT NOT NULL,
   uuid uuid UNIQUE NOT NULL DEFAULT gen_random_uuid());

COMMENT ON TABLE building_type IS 'Look up table for the types of buildings available, e.g barns, cottages, etc.';
COMMENT ON COLUMN building_type.id IS 'The unique building type ID. This is the Primary Key.';
COMMENT ON COLUMN building_type.name IS 'The name is unique to the buildings table.';
COMMENT ON COLUMN building_type.notes IS 'Where we make comments and a description about the building_type.';
COMMENT ON COLUMN building_type.image IS 'The image link associated with the building type.';
COMMENT ON COLUMN building_type.last_update IS 'The timestamp shown for when the building type table has been updated.';
COMMENT ON COLUMN building_type.last_update_by IS 'The name of the person who updated the table last.';
COMMENT ON COLUMN building_type.uuid IS 'Global Unique Identifier.';


-- BUILDINGS --
CREATE TABLE IF NOT EXISTS building(
   id SERIAL PRIMARY KEY,
   name VARCHAR NOT NULL,
   notes TEXT NOT NULL,
   address TEXT NOT NULL,	
   image TEXT,
   geometry GEOMETRY(Polygon, 4326),
   area_square_meter FLOAT NOT NULL,
   height_meter FLOAT NOT NULL,	
   last_update TIMESTAMP DEFAULT now() NOT NULL,
   last_update_by TEXT NOT NULL,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   building_type_uuid UUID  NOT NULL REFERENCES building_type(uuid));

COMMENT ON TABLE building IS 'Look up table for the types of buildings available, e.g residential';
COMMENT ON COLUMN building.id IS 'The unique building type ID. This is the Primary Key.';
COMMENT ON COLUMN building.name IS 'The name is unique for the building table.';
COMMENT ON COLUMN building.notes IS 'Where we make comments and a description about the building_type.';
COMMENT ON COLUMN building.address IS 'The address of the building to locate it in space.';
COMMENT ON COLUMN building.image IS 'The image link associated with the building_type.';
COMMENT ON COLUMN building.geometry IS 'The geometry of building (point, line or polygon) and the projection system used.';
COMMENT ON COLUMN building.area_square_meter IS 'The area covered by the building on the ground in m^2.';
COMMENT ON COLUMN building.height_meter IS 'The height of building which can be influenced by the shadow it casts over the nearby area depending on the position of the sun.';
COMMENT ON COLUMN building.last_update IS 'The timestamp shown for when the table has been updated.';
COMMENT ON COLUMN building.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN building.building_type_uuid IS 'The foreign key which references the uuid from the building type table.';


--BUILDING MATERIAL--
CREATE TABLE IF NOT EXISTS building_material(
id serial PRIMARY KEY,
name VARCHAR UNIQUE NOT NULL, --look up table names must be unique
notes TEXT,
image TEXT,
last_update TIMESTAMP DEFAULT now()NOT NULL,
last_update_by TEXT NOT NULL,
uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid());

COMMENT ON TABLE building_material IS 'Look up table for the types of building materials e.g. wood, concrete, aluminuim sheets etc.';
COMMENT ON COLUMN building_material.id IS 'The unique building material type ID. This is the Primary Key.';
COMMENT ON COLUMN building_material.name IS 'The name is unique to the buildings table since it is a look up table.';
COMMENT ON COLUMN building_material.notes IS 'Where we make comments and a description about the building material.';
COMMENT ON COLUMN building_material.image IS 'The image link associated with the building material.';
COMMENT ON COLUMN building_material.last_update IS 'The timestamp shown for when the building material table has been updated.';
COMMENT ON COLUMN building_material.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building_material.uuid IS 'Globally Unique Identifier.';

-- BUILDING MATERIALS --
CREATE TABLE IF NOT EXISTS building_materials( -- association table
uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),	
last_update TIMESTAMP DEFAULT now() NOT NULL,
last_update_by TEXT NOT NULL,
notes TEXT,
image TEXT,
date DATE NOT NULL,	
building_uuid UUID NOT NULL REFERENCES building(uuid),
building_material_uuid UUID NOT NULL REFERENCES building_material(uuid),
PRIMARY KEY (building_uuid, building_material_uuid,date), --composite keys
UNIQUE (building_uuid, building_material_uuid,date));

COMMENT ON TABLE building_materials IS 'An association table between building and building material.';
COMMENT ON COLUMN building_materials.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN building_materials.last_update IS 'The timestamp shown for when the table has been updated.';
COMMENT ON COLUMN building_materials.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building_materials.notes IS 'Where we make comments and a description about the building materials.';
COMMENT ON COLUMN building_materials.image IS 'The image link associated with the building materials.';
COMMENT ON COLUMN building_materials.date IS 'The datetime alteration of the conditions. This is the Primary and Composite Key';
COMMENT ON COLUMN building_materials.building_uuid IS 'The composite key referenced from the building table.';
COMMENT ON COLUMN building_materials.building_material_uuid IS 'The composite key referenced from the building material table.';


-- BUILDING CONDITIONS --
CREATE TABLE IF NOT EXISTS building_conditions( -- association table
uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),	
last_update TIMESTAMP DEFAULT now() NOT NULL,
last_update_by TEXT NOT NULL,
notes TEXT,
image TEXT,
date DATE NOT NULL,	
building_uuid UUID NOT NULL REFERENCES building(uuid),
condition_uuid UUID NOT NULL REFERENCES condition(uuid),
PRIMARY KEY (building_uuid, condition_uuid,date), --composite keys
UNIQUE (building_uuid, condition_uuid,date));

COMMENT ON TABLE building_conditions IS 'An association table between building and building conditions type.';
COMMENT ON COLUMN building_conditions.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN building_conditions.last_update IS 'The timestamp shown for when the table has been updated.';
COMMENT ON COLUMN building_conditions.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building_conditions.notes IS 'Where we make comments and a description about the building conditions.';
COMMENT ON COLUMN building_conditions.image IS 'The image link associated with the building conditions.';
COMMENT ON COLUMN building_conditions.date IS 'The datetime alteration of the conditions. This is the Primary and Composite Key';
COMMENT ON COLUMN building_conditions.building_uuid IS 'The composite key referenced from the building table.';
COMMENT ON COLUMN building_conditions.condition_uuid IS 'The composite key referenced from the building table.';



---------------------------------------- FENCES -------------------------------------


-- FENCE TYPE
CREATE TABLE IF NOT EXISTS fence_type (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT UNIQUE NOT NULL,
    notes TEXT,
    image TEXT,
    sort_order INT UNIQUE
);
COMMENT ON TABLE fence_type IS 'Look up table for fence types, e.g. electric, chain_link.';
COMMENT ON COLUMN fence_type.id IS 'The unique fence type item id. Primary key.';
COMMENT ON COLUMN fence_type.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN fence_type.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN fence_type.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN fence_type.name IS 'The name of the fence type item.';
COMMENT ON COLUMN fence_type.notes IS 'Additional information of the fence type item.';
COMMENT ON COLUMN fence_type.image IS 'Image of the fence type item.';


-- FENCE LINE
CREATE TABLE IF NOT EXISTS fence (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    notes TEXT,
    image TEXT,
    height_m FLOAT,
    installation_date DATE NOT NULL,
    is_date_estimated BOOLEAN,
    geometry GEOMETRY(LINESTRING, 4326) NOT NULL,
    fence_type_uuid UUID NOT NULL REFERENCES fence_type(uuid)
);
COMMENT ON TABLE fence IS 'The fence item refers to any geolocated line acting as boundary in the area, e.g. fence lines';
COMMENT ON COLUMN fence.id IS 'The unique fence item id. Primary key.';
COMMENT ON COLUMN fence.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN fence.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN fence.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN fence.notes IS 'Additional information of the fence item.';
COMMENT ON COLUMN fence.image IS 'Image of the fence item.';
COMMENT ON COLUMN fence.height_m IS 'Height of the fence in meters';
COMMENT ON COLUMN fence.installation_date IS 'The date the fence was installed.';
COMMENT ON COLUMN fence.is_date_estimated IS 'Is the fence item date of construction estimated?';
COMMENT ON COLUMN fence.geometry IS 'The location of the fence line. Follows EPSG: 4326.';

-- ASSOCIATION TABLE
-- FENCE CONDITIONS
CREATE TABLE IF NOT EXISTS fence_conditions (
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    notes TEXT,
    image TEXT,
    DATE DATE NOT NULL,
    fence_uuid UUID NOT NULL REFERENCES fence(uuid),
    condition_uuid UUID NOT NULL REFERENCES condition(uuid),
    -- composite primary key
    PRIMARY key (fence_uuid, condition_uuid, DATE),
    -- unique together
    UNIQUE(fence_uuid, condition_uuid, DATE)
);
COMMENT ON TABLE fence_conditions IS 'An Association table showing the fence conditions, e.g. good, bad.';
COMMENT ON COLUMN fence_conditions.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN fence_conditions.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN fence_conditions.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN fence_conditions.notes IS 'Additional information of the fence conditions item.';
COMMENT ON COLUMN fence_conditions.image IS 'Image of the fence conditions item.';
COMMENT ON COLUMN fence_conditions."date" IS 'The date of the current conditions are marked as changed';

-- POINT OF INTEREST TYPE
CREATE TABLE IF NOT EXISTS point_of_interest_type (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT UNIQUE NOT NULL,
    notes TEXT,
    image TEXT,
    sort_order INT UNIQUE
);
COMMENT ON TABLE point_of_interest_type IS 'Look up tables for point of interest types, e.g. types of gates';
COMMENT ON COLUMN point_of_interest_type.id IS 'The unique point of interest type item id. Primary key.';
COMMENT ON COLUMN point_of_interest_type.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN point_of_interest_type.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN point_of_interest_type.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN point_of_interest_type.name IS 'The name of the point of interest type.';
COMMENT ON COLUMN point_of_interest_type.notes IS 'Additional information of the point of interest type.';
COMMENT ON COLUMN point_of_interest_type.image IS 'Image of the point of interest type.';
COMMENT ON COLUMN point_of_interest_type.sort_order IS 'The pattern of how point of interest types are to be sorted.';

-- POINT OF INTEREST
CREATE TABLE IF NOT EXISTS point_of_interest (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT,
    notes TEXT,
    image TEXT,
    height_m FLOAT,
    installation_date DATE,
    is_date_estimated BOOLEAN,
    geometry GEOMETRY(POINT, 4326) NOT NULL,
    point_of_interest_type_uuid UUID NOT NULL REFERENCES point_of_interest_type(uuid)
);
COMMENT ON TABLE point_of_interest IS 'The point of interest item refers to any geolocated point features found in the area, e.g. gate, ruin.';
COMMENT ON COLUMN point_of_interest.id IS 'The unique point of interest item id. Primary key.';
COMMENT ON COLUMN point_of_interest.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN point_of_interest.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN point_of_interest.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN point_of_interest.name IS 'The name of the point of interest item.';
COMMENT ON COLUMN point_of_interest.notes IS 'Additional information of the point of interest item.';
COMMENT ON COLUMN point_of_interest.image IS 'Image of the point of interest item.';
COMMENT ON COLUMN point_of_interest.height_m IS 'The height in meters of the point of interest.';
COMMENT ON COLUMN point_of_interest.installation_date IS 'The date the point of interest feature was installed/constructed.';
COMMENT ON COLUMN point_of_interest.is_date_estimated IS 'Is the point of interest date of construction estimated?';
COMMENT ON COLUMN point_of_interest.geometry IS 'The centroid location of the point of interest item. Follows EPSG: 4326.';

-- ASSOCIATION TABLE
-- POINT OF INTEREST CONDITIONS
CREATE TABLE IF NOT EXISTS point_of_interest_conditions (
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    notes TEXT,
    image TEXT,
    DATE DATE NOT NULL,
    point_of_interest_uuid UUID NOT NULL REFERENCES point_of_interest(uuid),
    condition_uuid UUID NOT NULL REFERENCES condition(uuid),
    -- composite primary key
    PRIMARY key (point_of_interest_uuid, condition_uuid, DATE),
    -- unique together
    UNIQUE(point_of_interest_uuid, condition_uuid, DATE)
);
COMMENT ON TABLE point_of_interest_conditions IS 'An Association table for point of interest conditions, e.g. good, bad.';
COMMENT ON COLUMN point_of_interest_conditions.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN point_of_interest_conditions.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN point_of_interest_conditions.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN point_of_interest_conditions.notes IS 'Additional information of the point of interest conditions item.';
COMMENT ON COLUMN point_of_interest_conditions.image IS 'Image of the point of interest conditions item.';
COMMENT ON COLUMN point_of_interest_conditions."date" IS 'The points of interest inspection date.';



----------------------------------------LANDUSE AREA -------------------------------------

-- LANDUSE AREA TYPE
CREATE TABLE IF NOT EXISTS landuse_area_type(
    	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
   	 last_update_by TEXT NOT NULL,
   	 name VARCHAR UNIQUE NOT NULL,
	notes TEXT,
	image TEXT
);
COMMENT ON TABLE landuse_area_type is 'Lookup table for the landuse area type. Eg: Agriculture, residential, recreation, commercial, transportation etc';
COMMENT ON COLUMN landuse_area_type.id is 'The unique landuse area type ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area_type.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_type.name is 'The landuse area type field name. This is unique.';
COMMENT ON COLUMN landuse_area_type.notes is 'Additional information of the landuse area type.';
COMMENT ON COLUMN landuse_area_type.image is 'Image of the landuse area type.';

-- LANDUSE AREA OWNERSHIP TYPE
CREATE TABLE IF NOT EXISTS landuse_area_ownership_type(
    	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
   	last_update_by TEXT NOT NULL,
    	name VARCHAR UNIQUE NOT NULL,
	notes TEXT,
	image TEXT
);
COMMENT ON TABLE landuse_area_ownership_type is 'Lookup table for the landuse area ownership type. Eg: Public or private ';
COMMENT ON COLUMN landuse_area_ownership_type.id is 'The unique landuse area ownership type ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area_ownership_type.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_ownership_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_ownership_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_ownership_type.name is 'The landuse area ownership type field name. This is unique.';
COMMENT ON COLUMN landuse_area_ownership_type.notes is 'Additional information of the landuse area ownership type.';
COMMENT ON COLUMN landuse_area_ownership_type.image is 'Image of the landuse area ownership type.';


-- LANDUSE AREA OWNER
CREATE TABLE IF NOT EXISTS landuse_area_owner(
    	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
    	name VARCHAR UNIQUE,
	notes TEXT,
	image TEXT,
	address TEXT,
	landuse_area_ownership_type_uuid UUID  NOT NULL REFERENCES landuse_area_ownership_type(uuid)
);
COMMENT ON TABLE landuse_area_owner is 'Lookup table for the landuse area owner. ';
COMMENT ON COLUMN landuse_area_owner.id is 'The unique landuse area owner ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area_owner.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_owner.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_owner.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_owner.name is 'The landuse area ownership field name. This is unique.';
COMMENT ON COLUMN landuse_area_owner.notes is 'Additional information of the landuse area owner.';
COMMENT ON COLUMN landuse_area_owner.image is 'Image of the landuse area owner.';
COMMENT ON COLUMN landuse_area_owner.address is 'Address of the owner of the landuse area.';
COMMENT ON COLUMN landuse_area_owner.landuse_area_ownership_type_uuid is 'The foreign key which references the uuid from the landuse area ownership type table.';


-- LANDUSE AREA
CREATE TABLE IF NOT EXISTS landuse_area(
    	id SERIAL NOT NULL PRIMARY KEY,
    	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
   	last_update_by TEXT NOT NULL,
   	 name VARCHAR UNIQUE,
	notes TEXT,
	image TEXT,
    	geometry GEOMETRY(POLYGON, 4326),
    	landuse_area_type_uuid UUID  NOT NULL REFERENCES landuse_area_type(uuid),
    	landuse_area_owner_uuid UUID  NOT NULL REFERENCES landuse_area_owner(uuid)
);
COMMENT ON TABLE landuse_area is 'Lookup table for the landuse area.';
COMMENT ON COLUMN landuse_area.id is 'The unique landuse area ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area.name is 'The landuse area name. This is unique.';
COMMENT ON COLUMN landuse_area.notes is 'Additional information of the landuse area.';
COMMENT ON COLUMN landuse_area.image is 'Image of the landuse area.';
COMMENT ON COLUMN landuse_area.geometry is 'The geometry of landuse (in this case a polygon) and the projection system used.';
COMMENT ON COLUMN landuse_area.landuse_area_type_uuid is 'The foreign key which references the uuid from the landuse area type table.';
COMMENT ON COLUMN landuse_area.landuse_area_owner_uuid is 'The foreign key which references the uuid from the landuse area owner table.';


-- LANDUSE AREA CONDITION TYPE
CREATE TABLE IF NOT EXISTS landuse_area_condition_type(
   	id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
   	last_update_by TEXT NOT NULL,
    	name VARCHAR UNIQUE NOT NULL, --lookup names must be unique
	notes TEXT,
	image TEXT
);
COMMENT ON TABLE landuse_area_condition_type is 'Lookup table for the landuse area condition type. e.g. Bare, Occupied, Work in Progress';
COMMENT ON COLUMN landuse_area_condition_type.id is 'The unique landuse area condition type ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area_condition_type.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_condition_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_condition_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_condition_type.name is 'The landuse area condition type field name.';
COMMENT ON COLUMN landuse_area_condition_type.notes is 'Additional information of the landuse area condition type.';
COMMENT ON COLUMN landuse_area_condition_type.image is 'Image of the landuse area condition type.';

-- ASSOCIATION TABLE
-- LANDUSE AREA CONDITIONS
CREATE TABLE IF NOT EXISTS landuse_area_conditions (
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
    	name VARCHAR UNIQUE,
	notes TEXT,
	image TEXT,
    	date DATE NOT NULL,
    	landuse_area_condition_type_uuid UUID NOT NULL REFERENCES landuse_area_condition_type(uuid),
    	landuse_area_uuid UUID NOT NULL REFERENCES landuse_area(uuid),
	-- Composite primary key
    	PRIMARY KEY (landuse_area_condition_type_uuid, landuse_area_uuid, date), 
	-- Unique together
   	 UNIQUE (landuse_area_condition_type_uuid, landuse_area_uuid, date)
);
COMMENT ON TABLE landuse_area_conditions is 'Associative table to store the landuse area of different landuse area condition type.';
COMMENT ON COLUMN landuse_area_conditions.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_conditions.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_conditions.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_conditions.name is 'The landuse area conditions name which is unique.';
COMMENT ON COLUMN landuse_area_conditions.notes is 'Additional information of the landuse area conditions.';
COMMENT ON COLUMN landuse_area_conditions.image is 'Image of the landuse area conditions.';
COMMENT ON COLUMN landuse_area_conditions.date iS 'The datetime alteration of the conditions. This is the Primary and Composite Key';
COMMENT ON COLUMN landuse_area_conditions.landuse_area_uuid is 'The foreign key linking to the landuse area table''s UUID.';
COMMENT ON COLUMN landuse_area_conditions.landuse_area_condition_type_uuid is 'The foreign key linking to the landuse area condition type table''s UUID.';

