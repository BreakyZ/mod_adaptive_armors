::Mod_Adaptive.HooksMod.hook("scripts/skills/perks/perk_legend_adaptive", function( q ) 
{	
	q.getPossibleTrees = @(__original) function()
	{
		local item, itemtype, newTree; // newTree may be a single Tree or an array of Trees
		local actor = this.getContainer().getActor();
		local armor_weight = 0

		// First, try to give a new Tree based on the equipped mainhand item
		if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null) 
		{
			item = actor.getMainhandItem();
			if (item.isItemType(this.Const.Items.ItemType.Weapon)) newTree = this.getWeaponPerkTree(item);
			newTree = this.getOnlyNonExistingTrees(newTree); // filter out Trees this character already has
			if (newTree != null && newTree.len()>0) return newTree;
		}
		// Next, try to give a new Tree based on the equipped offhand item
		if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
		{
			item = actor.getOffhandItem();
			if (item.isItemType(this.Const.Items.ItemType.Shield)) newTree = this.getShieldPerkTree(item);
			else newTree = this.getMiscPerkTree(item);
			newTree = this.getOnlyNonExistingTrees(newTree); // filter out Trees this character already has
			if (newTree != null && newTree.len()>0) return newTree;
		}

		if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null && actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			// Attempt to give Unarmed if no weapons are equipped
			newTree = this.getOnlyNonExistingTrees(this.Const.Perks.FistsClassTree);
			if (newTree != null && newTree.len()>0) return newTree;
		}

		if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
		{
			armor_weight += actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head).getStaminaModifier()
		}

		if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
		{
			armor_weight += actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getStaminaModifier()
		}

		if (armor_weight >= -15 && armor_weight <= 0)
		{	
			// Attempt to give light armor tree if in range or naked
			newTree = this.getOnlyNonExistingTrees(this.Const.Perks.LightArmorTree);
			if (newTree != null && newTree.len()>0) return newTree;
		}

		if (armor_weight >= -35 && armor_weight < -15)
		{	
			// Attempt to give medium armor tree
			newTree = this.getOnlyNonExistingTrees(this.Const.Perks.MediumArmorTree);
			if (newTree != null && newTree.len()>0) return newTree;
		}

		if (armor_weight < -35)
		{	
			// Attempt to give heavy armor tree
			newTree = this.getOnlyNonExistingTrees(this.Const.Perks.HeavyArmorTree);
			if (newTree != null && newTree.len()>0) return newTree;
		}

		// If none of the equipped items (or unarmed or armors) granted any Trees, then consider the following Trees
		if (newTree == null || newTree.len()<1)
		{
			newTree = [
				this.Const.Perks.AgileTree,
				this.Const.Perks.IndestructibleTree,
				this.Const.Perks.MartyrTree,
				this.Const.Perks.ViciousTree,
				this.Const.Perks.DeviousTree,
				this.Const.Perks.InspirationalTree,
				this.Const.Perks.IntelligentTree,
				this.Const.Perks.CalmTree,
				this.Const.Perks.FastTree,
				this.Const.Perks.LargeTree,
				this.Const.Perks.OrganisedTree,
				this.Const.Perks.SturdyTree,
				this.Const.Perks.FitTree,
				this.Const.Perks.TrainedTree
			];
		}
		
		newTree = this.getOnlyNonExistingTrees(newTree); // filter out Trees this character already has

		// Give PhilosophyMagicTree if there are still no possible Trees
		if(newTree == null || newTree.len()<1)
		{
			newTree = this.Const.Perks.PhilosophyMagicTree.Tree;
		}

		return newTree;
	}

	q.onUpdateLevel <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.m.Level == 18)
		{
			actor.m.PerkPoints += 1;
		}
	}
});