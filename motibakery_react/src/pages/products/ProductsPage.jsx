import { PageHeader } from '@/components/shared/PageHeader';
import { DataTable } from '@/components/shared/DataTable';
import { StatusBadge } from '@/components/shared/StatusBadge';

const columns = [
  { key: 'id', label: 'ID' },
  { key: 'name', label: 'Name' },
  { key: 'category', label: 'Category' },
  { key: 'rate', label: 'Rate' },
  { key: 'weight', label: 'Weight' },
  { key: 'flavours', label: 'Flavours' },
  { key: 'status', label: 'Status', render: (row) => <StatusBadge status={row.status} /> },
];

const rows = [
  { id: '#C001', name: 'Black Forest', category: 'Chocolate', rate: '₹380/kg', weight: '0.5 - 4 kg', flavours: '3', status: 'active' },
  { id: '#C002', name: 'Strawberry Dream', category: 'Fruit', rate: '₹320/kg', weight: '1 - 3 kg', flavours: '2', status: 'active' },
  { id: '#C003', name: 'Classic Vanilla', category: 'Standard', rate: '₹280/kg', weight: '0.5 - 3 kg', flavours: '1', status: 'inactive' },
];

export function ProductsPage() {
  return (
    <div>
      <PageHeader
        title="Products"
        subtitle="Cake Catalogue"
        action={{ label: '+ Add Cake', onClick: () => {} }}
        secondaryAction={{ label: 'Import Excel', onClick: () => {} }}
      />

      <div className="mb-4 flex flex-wrap gap-3">
        <input className="h-10 min-w-[220px] rounded-md border border-gray-300 px-3 text-sm" placeholder="Search cakes..." />
        <select className="h-10 rounded-md border border-gray-300 px-3 text-sm">
          <option>All Categories</option>
        </select>
        <select className="h-10 rounded-md border border-gray-300 px-3 text-sm">
          <option>All Status</option>
        </select>
      </div>

      <DataTable columns={columns} rows={rows} emptyText="No cakes found" />
    </div>
  );
}
