trait IInventory:
    """Interface for an inventory of names with specific quantities."""

    fn __len__(self) -> Int32:
        ...

    fn __getitem__(self, item: String) -> Float32:
        ...

    fn __setitem__(self, item: String, quantity: Float32):
        ...

    fn __delitem__(self, item: String):
        ...

    fn __contains__(self, item: String) -> Bool:
        ...

    fn __eq__(self, other: Self) -> Bool:
        ...

    fn add(self, item: String, quantity: Float32):
        """Add the given quantity of an item to the inventory.

        If the quantity is negative, the item is removed instead.

        Arguments:
            item (String): The name of the item to add.
            quantity (Float32): The quantity of the item to add. Defaults to 1.
        """
        ...

    fn remove(self, item: String):
        """Remove the given item from the inventory completely.

        Arguments:
            - item (String): The name of the item to remove.
        """
        ...

    fn remove(self, item: String, quantity: Float32):
        """Remove the given quantity of an item from the inventory.

        If the quantity is negative, the item is added instead.

        Arguments:
            - item (String): The name of the item to remove.
            - quantity (Float32): The quantity of the item to remove.
        """
        ...

    fn items(self):
        """Return an iterator over the items in the inventory."""
        ...

    fn names(self):
        """Return an iterator over the item names in the inventory."""
        ...


from python import Python


struct Inventory(IInventory):
    # what type is this
    var __inventory: python.Dictionary

    """The dictionary representing the inventory, where the keys are item names and the values are quantities."""

    fn __init__(inout self):
        """
        Initialize the Inventory object.
        """
        self.__inventory = Python.dict()

    # no **kwargs possible
    fn __init__(inout self, items: python.Dictionary):
        """
        Initialize the Inventory object.

        Arguments:
            - **items (float): The items to initialize the inventory with.
        """
        self.__inventory = items

    fn __len__(self):
        # no len in dictionary yet
        return len(self.__inventory)

    fn __getitem__(self, item: String):
        # no "in" supported yet
        return self.__inventory[item] if item in self.__inventory else 0

    fn __setitem__(self, item: String, quantity: Float32):
        if quantity <= 0:
            self.remove(item)
        # no "in" supported yet
        elif item not in self.__inventory:
            self.__inventory[item] = quantity

    fn __delitem__(self, item: String):
        self.remove(item)

    fn __contains__(self, item: String):
        # no "in" supported yet
        return item in self.__inventory

    fn __eq__(self, other: Self):
        # dictionary does not implement __eq__
        return self.__inventory == other.__inventory

    fn __eq__(self, other: python.Dictionary):
        # dictionary does not implement __eq__
        return self.__inventory == other

    fn add(self, item: String, quantity: Float32):
        if quantity == 0:
            return

        if quantity < 0:
            self.remove(item, -quantity)
        # no "in" supported yet
        elif item not in self.__inventory:
            self.__inventory[item] = quantity
        else:
            self.__inventory[item] += quantity

    fn remove(self, item: String):
        # no "in" supported yet
        if item in self.__inventory:
            del self.__inventory[item]

    fn remove(self, item: String, quantity: Float32):
        if quantity < 0:
            self.add(item, -quantity)
            return
        if item not in self.__inventory:
            return
        stored = self.__inventory[item]
        if stored <= quantity:
            del self.__inventory[item]
        else:
            self.__inventory[item] -= quantity

    fn items(self):
        # why does this raise an exception?
        return self.__inventory.items()

    fn names(self):
        # why does this raise an exception?
        return self.__inventory.keys()
