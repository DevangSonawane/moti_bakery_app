import { PageHeader } from '@/components/shared/PageHeader';
import { DataTable } from '@/components/shared/DataTable';
import { StatusBadge } from '@/components/shared/StatusBadge';

const columns = [
  { key: 'name', label: 'Name' },
  { key: 'email', label: 'Email' },
  { key: 'role', label: 'Role' },
  { key: 'status', label: 'Status', render: (row) => <StatusBadge status={row.status} /> },
  { key: 'lastLogin', label: 'Last Login' },
];

const rows = [
  {
    name: 'Priya Shah',
    email: 'counter1@motibakery.com',
    role: 'Counter',
    status: 'active',
    lastLogin: 'Today 9AM',
  },
  {
    name: 'Rajan Mehta',
    email: 'cakeroom@motibakery.com',
    role: 'Cake Room',
    status: 'active',
    lastLogin: 'Today 8:50AM',
  },
  {
    name: 'Old Staff',
    email: 'old@motibakery.com',
    role: 'Counter',
    status: 'inactive',
    lastLogin: '3 weeks ago',
  },
];

export function UsersPage() {
  return (
    <div>
      <PageHeader title="Users" subtitle="Manage access" action={{ label: '+ Add User', onClick: () => {} }} />

      <div className="mb-4 flex flex-wrap gap-3">
        <input className="h-10 min-w-[220px] rounded-md border border-gray-300 px-3 text-sm" placeholder="Search users..." />
        <select className="h-10 rounded-md border border-gray-300 px-3 text-sm">
          <option>All Roles</option>
        </select>
        <select className="h-10 rounded-md border border-gray-300 px-3 text-sm">
          <option>All Status</option>
        </select>
      </div>

      <DataTable columns={columns} rows={rows} emptyText="No users found" />
    </div>
  );
}
