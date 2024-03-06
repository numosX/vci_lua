local box_obj   = vci.assets.GetTransform("cube")
local plane_obj = vci.assets.GetTransform("plane")

local dr_vec        = Vector3.__new(0,0,0)
local q_box_0       = Quaternion.identity
local q_box_1       = Quaternion.identity
local q_plane_0     = Quaternion.identity
local q_plane_1     = Quaternion.identity
local is_box_moving = false


function onGrab(obj_name)
    if obj_name == "cube" then
        is_box_moving = true
    end
end

function onUngrab(obj_name)
    if obj_name == "cube" then
        is_box_moving = false
    end
    save_initial_condition()
end

function updateAll()
    if not is_box_moving then return end
    update_plane()
end    

function save_initial_condition()
    dr_vec      = plane_obj.GetPosition() - box_obj.GetPosition()
    q_box_0     = box_obj.GetRotation()
    q_plane_0   = plane_obj.GetRotation()
end

function update_plane()
    r_box_1     = box_obj.GetPosition()
    q_box_1     = box_obj.GetRotation()
    
    dq_box      = q_box_1 * Quaternion.Inverse(q_box_0)

    r_plane_1   = r_box_1 + dq_box * dr_vec
    q_plane_1   = dq_box * q_plane_0

    plane_obj.SetPosition(r_plane_1)
    plane_obj.SetRotation(q_plane_1)
end

save_initial_condition()
