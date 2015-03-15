local Pickler = Class(function(self, inst)
    self.inst = inst


    self._pickleperson = net_entity(inst.GUID, "pickler._pickleperson")
end)

function Pickler:SetPicklePerson(pickleperson)
    self._pickleperson:set(pickleperson)
end

function Pickler:GetPicklePerson()
    return self._pickleperson:value()
end

return Pickler