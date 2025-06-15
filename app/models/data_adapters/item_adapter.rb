module DataAdapters
  class ItemAdapter
    def update_pending_buyer_comments(items)
      filtered = items.select { |_, v| %w[Approved Pending].include?(v["buyer_approved"]) }
      return 'No items updated as there was no change' if filtered.empty?
      filtered.each do |item_id, hash|
        item = Item.find(item_id)
        item.update(buyer_approved: hash[:buyer_approved], remarks: hash[:remarks])
      end
      'Vendor Comments and remarks updated successfully.'
    end

    def update_pending_buyer_approval(items)
      ids = items[:id].keys
      Item.where(id: ids).update_all(buyer_approved: 'Approved')
    end

    def update_buyer_approved_items(items)
      ids = items[:id].keys
      Item.where(id: ids).update_all(buyer_approved: 'Pending')
    end

  end

end
